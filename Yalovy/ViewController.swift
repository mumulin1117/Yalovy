import UIKit
import WebKit
import StoreKit

class ViewController: UIViewController, WKScriptMessageHandler {
    private static let iapMessageHandlerName = "PoetryIAP"
    private static let diagnosticsMessageHandlerName = "YalovyDiagnostics"
    private var isDisplayingWebError = false
    private var hasStartedBundledApp = false
    private lazy var scriptMessageProxy = WeakScriptMessageHandler(delegate: self)

    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(Self.storageRepairScript)
        configuration.userContentController.addUserScript(Self.diagnosticsScript)
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        webView.scrollView.backgroundColor = webView.backgroundColor
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    private let loadingOverlay: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LaunchImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1)
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        configureWebViewCallbacks()
        installWebView()
        installLoadingOverlay()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !hasStartedBundledApp else { return }
        hasStartedBundledApp = true
        loadBundledApp()
    }

    private func configureWebViewCallbacks() {
        let contentController = webView.configuration.userContentController
        contentController.add(scriptMessageProxy, name: Self.iapMessageHandlerName)
        contentController.add(scriptMessageProxy, name: Self.diagnosticsMessageHandlerName)
    }

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(
            forName: Self.iapMessageHandlerName
        )
        webView.configuration.userContentController.removeScriptMessageHandler(
            forName: Self.diagnosticsMessageHandlerName
        )
    }

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        if message.name == Self.diagnosticsMessageHandlerName {
            let diagnostics = message.body as? [String: Any]
            if diagnostics?["type"] as? String == "ready" {
                UIView.animate(withDuration: 0.2, animations: {
                    self.loadingOverlay.alpha = 0
                }, completion: { _ in
                    self.loadingOverlay.removeFromSuperview()
                })
                return
            }

            let detail = diagnostics?["message"] as? String
                ?? "The web application could not start."
            showWebError(detail)
            return
        }

        guard message.name == Self.iapMessageHandlerName,
              let payload = message.body as? [String: Any],
              payload["type"] as? String == "startPurchase" else {
            return
        }

        let data = payload["data"] as? [String: Any]
        let productID = Self.stringValue(payload["productId"])
            ?? Self.stringValue(data?["product_id"])
        let requestID = Self.stringValue(payload["request_id"])
            ?? Self.stringValue(data?["request_id"])
            ?? ""
        let packageID = Self.stringValue(data?["package_id"])
            ?? productID
            ?? ""
        let userID = Self.stringValue(payload["user_id"])
            ?? Self.stringValue(data?["user_id"])
            ?? ""

        guard let productID, !productID.isEmpty else {
            sendPurchaseFailure(
                requestID: requestID,
                packageID: packageID,
                message: "Invalid in-app purchase product."
            )
            return
        }

        Task { @MainActor [weak self] in
            await self?.purchase(
                productID: productID,
                packageID: packageID,
                requestID: requestID,
                userID: userID
            )
        }
    }

    private func showWebError(_ detail: String) {
        guard !isDisplayingWebError else { return }
        isDisplayingWebError = true
        loadingOverlay.removeFromSuperview()
        let escapedDetail = detail
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")

        webView.loadHTMLString(
            Self.webErrorHTML.replacingOccurrences(of: "{{DETAIL}}", with: escapedDetail),
            baseURL: nil
        )
    }

    @MainActor
    private func purchase(
        productID: String,
        packageID: String,
        requestID: String,
        userID: String
    ) async {
        guard Self.configuredProductIDs.contains(productID) else {
            sendPurchaseFailure(
                requestID: requestID,
                packageID: packageID,
                message: "This in-app purchase is not configured."
            )
            return
        }

        do {
            guard let product = try await Product.products(for: [productID]).first else {
                sendPurchaseFailure(
                    requestID: requestID,
                    packageID: packageID,
                    message: "This product is unavailable from the App Store."
                )
                return
            }

            switch try await product.purchase() {
            case .success(let verificationResult):
                let transaction = try Self.verified(verificationResult)
                guard transaction.productID == productID else {
                    throw PurchaseError.productMismatch
                }

                await transaction.finish()
                sendIAPResult([
                    "status": "success",
                    "request_id": requestID,
                    "package_id": packageID,
                    "product_id": productID,
                    "transaction_id": String(transaction.id),
                    "user_id": userID
                ])

            case .pending:
                sendPurchaseFailure(
                    requestID: requestID,
                    packageID: packageID,
                    message: "Purchase is pending approval."
                )

            case .userCancelled:
                sendPurchaseFailure(
                    requestID: requestID,
                    packageID: packageID,
                    message: "Purchase cancelled."
                )

            @unknown default:
                sendPurchaseFailure(
                    requestID: requestID,
                    packageID: packageID,
                    message: "The App Store returned an unknown purchase result."
                )
            }
        } catch {
            sendPurchaseFailure(
                requestID: requestID,
                packageID: packageID,
                message: Self.purchaseErrorMessage(error)
            )
        }
    }

    @MainActor
    private func sendPurchaseFailure(requestID: String, packageID: String, message: String) {
        sendIAPResult([
            "status": "failed",
            "request_id": requestID,
            "package_id": packageID,
            "message": message
        ])
    }

    @MainActor
    private func sendIAPResult(_ result: [String: Any]) {
        guard JSONSerialization.isValidJSONObject(result),
              let data = try? JSONSerialization.data(withJSONObject: result),
              let json = String(data: data, encoding: .utf8) else {
            return
        }

        let script = "window.PoetryIAP && window.PoetryIAP.receive(\(json));"
        webView.evaluateJavaScript(script)
    }

    private static func verified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let value):
            return value
        case .unverified:
            throw PurchaseError.failedVerification
        }
    }

    private static func stringValue(_ value: Any?) -> String? {
        guard let value = value as? String else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func purchaseErrorMessage(_ error: Error) -> String {
        if error is PurchaseError {
            return "The App Store transaction could not be verified."
        }

        let nsError = error as NSError
        if nsError.domain == SKError.errorDomain,
           let storeError = SKError.Code(rawValue: nsError.code) {
            switch storeError {
            case .paymentNotAllowed:
                return "In-app purchases are disabled on this device."
            case .storeProductNotAvailable:
                return "This product is unavailable from the App Store."
            default:
                break
            }
        }

        if nsError.domain == NSURLErrorDomain {
            return "Unable to connect to the App Store."
        }

        return error.localizedDescription
    }

    private static let configuredProductIDs: Set<String> = {
        guard let url = Bundle.main.url(
            forResource: "coin-packages",
            withExtension: "json",
            subdirectory: "static/common.config"
        ),
        let data = try? Data(contentsOf: url),
        let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        let packages = root["coin_packages"] as? [[String: Any]] else {
            return []
        }

        return Set(packages.compactMap { stringValue($0["product_id"]) })
    }()

    private enum PurchaseError: Error {
        case failedVerification
        case productMismatch
    }

    private func installWebView() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func installLoadingOverlay() {
        view.addSubview(loadingOverlay)
        NSLayoutConstraint.activate([
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadBundledApp() {
        guard let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html") else {
//            webView.loadHTMLString(Self.missingFileHTML, baseURL: nil)
            return
        }

        isDisplayingWebError = false
        var components = URLComponents(url: htmlURL, resolvingAgainstBaseURL: false)
        components?.fragment = "/"
        let appURL = components?.url ?? htmlURL
        webView.loadFileURL(appURL, allowingReadAccessTo: Bundle.main.bundleURL)
    }

//    private static let missingFileHTML = """
//    <!doctype html>
//    <html>
//    <body style="margin:0;background:#1a1b1d;color:#fff;font:-apple-system-body;padding:24px">
//      <h2>Yalovy app file missing</h2>
//      <p>Expected Bundle resource: index.html</p>
//    </body>
//    </html>
//    """

    private static let webErrorHTML = """
    <!doctype html>
    <html>
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
    <body style="margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;background:#1a1b1d;color:#fff;font-family:-apple-system;padding:28px;box-sizing:border-box;text-align:center">
      <div>
        <div style="font-size:22px;font-weight:800;margin-bottom:10px">Yalovy couldn't open</div>
        <div style="color:#9aa694;font-size:14px;line-height:1.5">{{DETAIL}}</div>
      </div>
    </body>
    </html>
    """

    private static let storageRepairScript = WKUserScript(
        source: """
        (function() {
          try {
            var repairKey = 'yalovy_native_storage_repaired_v3';
            if (window.localStorage && !window.localStorage.getItem(repairKey)) {
              window.localStorage.removeItem('pet_one_state');
              window.localStorage.setItem(repairKey, '1');
            }
          } catch (error) {}
        })();
        """,
        injectionTime: .atDocumentStart,
        forMainFrameOnly: true
    )

    private static let diagnosticsScript = WKUserScript(
        source: """
        (function() {
          function report(message) {
            if (!document.getElementById('native-web-fallback')) return;
            try {
              window.webkit.messageHandlers.YalovyDiagnostics.postMessage({
                type: 'error',
                message: String(message || 'Unknown JavaScript error')
              });
            } catch (error) {}
          }
          window.addEventListener('error', function(event) {
            report(event.message || (event.error && event.error.message));
          });
          window.addEventListener('unhandledrejection', function(event) {
            var reason = event.reason;
            report(reason && reason.message ? reason.message : reason);
          });
          window.addEventListener('DOMContentLoaded', function() {
            var startedAt = Date.now();
            var readinessTimer = setInterval(function() {
              try {
                var fallback = document.getElementById('native-web-fallback');
                if (!fallback) {
                  clearInterval(readinessTimer);
                  setTimeout(function() {
                    requestAnimationFrame(function() {
                      window.webkit.messageHandlers.YalovyDiagnostics.postMessage({ type: 'ready' });
                    });
                  }, 600);
                  return;
                }

                if (Date.now() - startedAt > 10000) {
                  clearInterval(readinessTimer);
                  window.webkit.messageHandlers.YalovyDiagnostics.postMessage({
                    type: 'error',
                    message: 'The web interface did not mount.'
                  });
                }
              } catch (error) {}
            }, 100);
          });
        })();
        """,
        injectionTime: .atDocumentStart,
        forMainFrameOnly: true
    )
}

private final class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
