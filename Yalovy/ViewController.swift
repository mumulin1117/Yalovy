import UIKit
import WebKit

class ViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(Self.storageRepairScript)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        installWebView()
        loadBundledApp()
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

    private func loadBundledApp() {
        guard let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html") else {
            webView.loadHTMLString(Self.missingFileHTML, baseURL: nil)
            return
        }

        var components = URLComponents(url: htmlURL, resolvingAgainstBaseURL: false)
        components?.fragment = "/"
        let appURL = components?.url ?? htmlURL
        webView.loadFileURL(appURL, allowingReadAccessTo: Bundle.main.bundleURL)
    }

    private static let missingFileHTML = """
    <!doctype html>
    <html>
    <body style="margin:0;background:#1a1b1d;color:#fff;font:-apple-system-body;padding:24px">
      <h2>Yalovy app file missing</h2>
      <p>Expected Bundle resource: index.html</p>
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
}
