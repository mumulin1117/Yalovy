import UIKit
import WebKit
import StoreKit

class ViewController: UIViewController, WKScriptMessageHandler {
    private static let storeBridgeName = "YalovyCatalogBridge"
    private static let diagnosticsBridgeName = "YalovyDiagnostics"
    private var isDisplayingBrowserError = false
    private var hasStartedBundledApp = false
    private lazy var scriptBridgeProxy = WeakScriptBridge(delegate: self)

    private lazy var browserSurface: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(Self.tokenOptionBootstrapScript)
        configuration.userContentController.addUserScript(Self.diagnosticsScript)
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let browserSurface = WKWebView(frame: .zero, configuration: configuration)
        browserSurface.translatesAutoresizingMaskIntoConstraints = false
        browserSurface.isOpaque = false
        browserSurface.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        browserSurface.scrollView.backgroundColor = browserSurface.backgroundColor
        browserSurface.scrollView.contentInsetAdjustmentBehavior = .never
        browserSurface.allowsBackForwardNavigationGestures = true
        return browserSurface
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
        configureBrowserCallbacks()
        installBrowserSurface()
        installLoadingOverlay()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !hasStartedBundledApp else { return }
        hasStartedBundledApp = true
        loadBundledApp()
    }

    private func configureBrowserCallbacks() {
        let contentController = browserSurface.configuration.userContentController
        contentController.add(scriptBridgeProxy, name: Self.storeBridgeName)
        contentController.add(scriptBridgeProxy, name: Self.diagnosticsBridgeName)
    }

    deinit {
        browserSurface.configuration.userContentController.removeScriptMessageHandler(
            forName: Self.storeBridgeName
        )
        browserSurface.configuration.userContentController.removeScriptMessageHandler(
            forName: Self.diagnosticsBridgeName
        )
    }

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive scriptPacket: WKScriptMessage
    ) {
        if scriptPacket.name == Self.diagnosticsBridgeName {
            let diagnostics = scriptPacket.body as? [String: Any]
            if diagnostics?["type"] as? String == "ready" {
                UIView.animate(withDuration: 0.2, animations: {
                    self.loadingOverlay.alpha = 0
                }, completion: { _ in
                    self.loadingOverlay.removeFromSuperview()
                })
                return
            }

            return
        }

        guard scriptPacket.name == Self.storeBridgeName,
              let packet = scriptPacket.body as? [String: Any],
              packet["type"] as? String == "startAcquisition" else {
            return
        }

        let data = packet["data"] as? [String: Any]
        let productID = Self.stringValue(packet["productId"])
            ?? Self.stringValue(data?["product_id"])
        let requestID = Self.stringValue(packet["request_id"])
            ?? Self.stringValue(data?["request_id"])
            ?? ""
        let optionID = Self.stringValue(data?["option_id"])
            ?? productID
            ?? ""
        let userID = Self.stringValue(packet["user_id"])
            ?? Self.stringValue(data?["user_id"])
            ?? ""

        guard let productID, !productID.isEmpty else {
            sendStoreFailure(
                requestID: requestID,
                optionID: optionID,
                detail: "Invalid App Store item."
            )
            return
        }

        Task { @MainActor [weak self] in
            await self?.acquire(
                productID: productID,
                optionID: optionID,
                requestID: requestID,
                userID: userID
            )
        }
    }


    @MainActor
    private func acquire(
        productID: String,
        optionID: String,
        requestID: String,
        userID: String
    ) async {
        guard Self.configuredItemIDs.contains(productID) else {
            sendStoreFailure(
                requestID: requestID,
                optionID: optionID,
                detail: "This App Store item is not configured."
            )
            return
        }

        do {
            guard let product = try await Product.products(for: [productID]).first else {
                sendStoreFailure(
                    requestID: requestID,
                    optionID: optionID,
                    detail: "This item is unavailable from the App Store."
                )
                return
            }

            switch try await product.purchase() {
            case .success(let verificationResult):
                let transaction = try Self.verified(verificationResult)
                guard transaction.productID == productID else {
                    throw StoreFlowError.productMismatch
                }

                await transaction.finish()
                sendStoreResult([
                    "status": "success",
                    "request_id": requestID,
                    "option_id": optionID,
                    "product_id": productID,
                    "transaction_id": String(transaction.id),
                    "user_id": userID
                ])

            case .pending:
                sendStoreFailure(
                    requestID: requestID,
                    optionID: optionID,
                    detail: "The request is pending approval."
                )

            case .userCancelled:
                sendStoreFailure(
                    requestID: requestID,
                    optionID: optionID,
                    detail: "The request was cancelled."
                )

            @unknown default:
                sendStoreFailure(
                    requestID: requestID,
                    optionID: optionID,
                    detail: "The App Store returned an unknown result."
                )
            }
        } catch {
            sendStoreFailure(
                requestID: requestID,
                optionID: optionID,
                detail: Self.storeFlowErrorText(error)
            )
        }
    }

    @MainActor
    private func sendStoreFailure(requestID: String, optionID: String, detail: String) {
        sendStoreResult([
            "status": "failed",
            "request_id": requestID,
            "option_id": optionID,
            "detail": detail
        ])
    }

    @MainActor
    private func sendStoreResult(_ result: [String: Any]) {
        guard JSONSerialization.isValidJSONObject(result),
              let data = try? JSONSerialization.data(withJSONObject: result),
              let json = String(data: data, encoding: .utf8) else {
            return
        }

        let script = "window.YalovyCatalogBridge && window.YalovyCatalogBridge.receive(\(json));"
        browserSurface.evaluateJavaScript(script)
    }

    private static func verified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let value):
            return value
        case .unverified:
            throw StoreFlowError.failedVerification
        }
    }

    private static func stringValue(_ value: Any?) -> String? {
        guard let value = value as? String else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func storeFlowErrorText(_ error: Error) -> String {
        if error is StoreFlowError {
            return "The App Store result could not be verified."
        }

        let nsError = error as NSError
        if nsError.domain == SKError.errorDomain,
           let storeError = SKError.Code(rawValue: nsError.code) {
            switch storeError {
            case .paymentNotAllowed:
                return "App Store requests are disabled on this device."
            case .storeProductNotAvailable:
                return "This item is unavailable from the App Store."
            default:
                break
            }
        }

        if nsError.domain == NSURLErrorDomain {
            return "Unable to connect to the App Store."
        }

        return error.localizedDescription
    }

    private static let configuredItemIDs: Set<String> = {
        guard let url = Bundle.main.url(
            forResource: "yalovy-token-options",
            withExtension: "json",
            subdirectory: "yalovy-content/store-catalog"
        ),
        let data = try? Data(contentsOf: url),
        let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        let packages = root["token_options"] as? [[String: Any]] else {
            return []
        }

        return Set(packages.compactMap { stringValue($0["product_id"]) })
    }()

    private enum StoreFlowError: Error {
        case failedVerification
        case productMismatch
    }

    private func installBrowserSurface() {
        view.addSubview(browserSurface)
        NSLayoutConstraint.activate([
            browserSurface.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            browserSurface.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            browserSurface.topAnchor.constraint(equalTo: view.topAnchor),
            browserSurface.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
            return
        }

        isDisplayingBrowserError = false
        var components = URLComponents(url: htmlURL, resolvingAgainstBaseURL: false)
        components?.fragment = "/"
        let appURL = components?.url ?? htmlURL
        browserSurface.loadFileURL(appURL, allowingReadAccessTo: Bundle.main.bundleURL)
    }


    private static let tokenOptionBootstrapScript: WKUserScript = {
        guard let url = Bundle.main.url(
            forResource: "yalovy-token-options",
            withExtension: "json",
            subdirectory: "yalovy-content/store-catalog"
        ),
        let data = try? Data(contentsOf: url),
        let configurationJSON = String(data: data, encoding: .utf8) else {
            return WKUserScript(
                source: "",
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
        }

        return WKUserScript(
            source: """
            (function() {
              var tokenOptionConfiguration = \(configurationJSON);
              var originalFetch = window.fetch ? window.fetch.bind(window) : null;

              window.fetch = function(input, init) {
                var requestURL = typeof input === 'string'
                  ? input
                  : (input && input.url ? input.url : '');

                if (requestURL.indexOf('yalovy-content/store-catalog/yalovy-token-options.json') !== -1) {
                  return Promise.resolve(new Response(
                    JSON.stringify(tokenOptionConfiguration),
                    {
                      status: 200,
                      headers: { 'Content-Type': 'application/json' }
                    }
                  ));
                }

                if (originalFetch) return originalFetch(input, init);
                return Promise.reject(new Error('Fetch is unavailable.'));
              };
            })();
            """,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
    }()

    private static let diagnosticsScript = WKUserScript(
        source: """
        (function() {
          function report(message) {
            if (!document.getElementById('native-browser-fallback')) return;
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
                var fallback = document.getElementById('native-browser-fallback');
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

private final class WeakScriptBridge: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive scriptPacket: WKScriptMessage
    ) {
        delegate?.userContentController(userContentController, didReceive: scriptPacket)
    }
}
