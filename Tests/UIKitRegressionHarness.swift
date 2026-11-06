import UIKit
import WebKit

private final class BStartupFixture: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        request.url?.host == AnniversaryMemoir.Environment.apiBaseURL.host
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    static var status = 200
    static var payload: [String: Any] = [:]
    static var calls = 0
    override func startLoading() {
        Self.calls += 1
        let response = HTTPURLResponse(url: request.url!, statusCode: Self.status, httpVersion: "HTTP/1.1", headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: try! JSONSerialization.data(withJSONObject: Self.payload))
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        precondition(freopen(output("startup-stdout.log").path, "w", stdout) != nil, "startup log capture unavailable")
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        self.window = window
        window.makeKeyAndVisible()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Task {
                await self.verifyStartup()
                self.runFixtures()
            }
        }
        return true
    }
    private func verifyStartup() async {
        let device = PetAlmanac.dawnImaginationCanvas()
        precondition(device == PetAlmanac.dawnImaginationCanvas(), "device identity is not stable")
        precondition(device != "fiuwhefiuwefweifgy" && device.hasSuffix("-yalovy"), "reference fixture identity leaked")
        URLProtocol.registerClass(BStartupFixture.self)
        defer { URLProtocol.unregisterClass(BStartupFixture.self) }
        for scenario in 0..<4 {
            BStartupFixture.calls = 0
            BStartupFixture.status = scenario == 2 ? 503 : 200
            BStartupFixture.payload = scenario == 1
                ? ["h5Url": "https://example.invalid/room", "roomId": "fixture", "webSocketUrl": "wss://realtime.ably.io/", "tokenResult": "fixture-token"]
                : scenario == 3 ? ["h5Url": "javascript:void(0)"] : [:]
            var controller: YalovyBStartupController?
            await withCheckedContinuation { continuation in
                controller = YalovyBStartupController(automatically: true) { configuration, webView in
                    precondition((configuration != nil) == (scenario == 1), "bootstrap branch mismatch")
                    precondition((webView != nil) == (scenario == 1), "prewarmed WebView branch mismatch")
                    continuation.resume()
                }
                controller?.loadViewIfNeeded()
            }
            precondition(BStartupFixture.calls == (scenario >= 2 ? AnniversaryMemoir.API.bootstrapAttempts : 1), "bootstrap retry policy mismatch")
            controller = nil
        }
        BStartupFixture.status = 200
        BStartupFixture.payload = [:]
        BStartupFixture.calls = 0
        let manual = YalovyBStartupController(automatically: false) { _, _ in preconditionFailure("manual connection started automatically") }
        manual.loadViewIfNeeded()
        precondition(BStartupFixture.calls == 0, "logout manual entry bypassed")
        print("Startup and device checks passed: fallback, B configuration, bounded network retries, invalid configuration, manual entry, Keychain persistence")
    }

    private func verifyIncomingPayment(_ session: MonthlyPlanner, controller: BirthdayKeepsake) {
        let isTest = AnniversaryMemoir.Environment.isDebug
        let selector = isTest ? "event" : "springAffinity"
        let action = isTest ? "pay" : "silkenThought"
        let productField = isTest ? "batchNo" : "tranquilFeelingTrail"
        let orderField = isTest ? "orderCode" : "crystalCuriosityCanvas"
        let foreign: [String: Any] = isTest ? ["springAffinity": "silkenThought"] : ["event": "pay"]
        session.onMessage?(foreign, nil)
        precondition(!descendants(controller.view).contains { $0.accessibilityIdentifier == purchaseAccessibilityID }, "other environment's payment message was accepted")
        for (fields, message) in [([productField: "fixture-product"], "The purchase request is invalid. Please try again later."),
                                  ([orderField: "fixture-order"], "This product is unavailable. Please try again later.")] {
            // 故意缺少一个字段，在进入 StoreKit 前验证真实 WebView 消息路由，不发起购买。
            session.onMessage?([selector: action, "data": fields], nil)
            let toast = descendants(controller.view).first { $0.accessibilityIdentifier == purchaseAccessibilityID }
            precondition(toast != nil, "selected environment's payment message was not routed")
            precondition(descendants(toast!).compactMap { ($0 as? UILabel)?.text }.contains(message), "payment identifiers used the wrong environment mapping")
        }
        let key = AnniversaryMemoir.Storage.productionPurchaseRecordsKey
        let previous = UserDefaults.standard.object(forKey: key)
        let data = Data("preserved-production-orders".utf8)
        UserDefaults.standard.set(data, forKey: key)
        CoatPortrait.tranquilCuriosityTrail = false
        precondition(!CoatPortrait.tranquilCuriosityTrail)
        precondition(UserDefaults.standard.data(forKey: key) == data, "entry state overwrote production orders")
        UserDefaults.standard.set(previous, forKey: key)
    }
    private func descendants(_ view: UIView) -> [UIView] { [view] + view.subviews.flatMap(descendants) }
    private var purchaseAccessibilityID: String {
        return AnniversaryMemoir.Presentation.purchaseAccessibilityID
    }
    private func rgba(_ color: UIColor?) -> [Double] {
        guard let color else { return [] }
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return [r, g, b, a].map { Double($0) }
    }
    private func snapshot(_ root: UIView, views: [UIView]) -> [[String: Any]] {
        views.filter { $0 is UILabel || $0 is UIButton || $0 is UIStackView || $0 is UIActivityIndicatorView }.map {
            let frame = $0.convert($0.bounds, to: root)
            var result: [String: Any] = ["type": String(describing: type(of: $0)),
                "frame": [frame.minX, frame.minY, frame.width, frame.height].map { (Double($0) * 100).rounded() / 100 },
                "hidden": $0.isHidden, "alpha": Double($0.alpha), "background": rgba($0.backgroundColor)]
            if let label = $0 as? UILabel {
                result["text"] = label.text ?? ""
                result["fontSize"] = Double(label.font.pointSize)
                result["font"] = label.font.fontName
                result["color"] = rgba(label.textColor)
                result["lines"] = label.numberOfLines
            }
            if let button = $0 as? UIButton { result["enabled"] = button.isEnabled }
            return result
        }
    }
    private func runFixtures() {
        UIView.setAnimationsEnabled(false)
        let sizes = [(320, 568), (375, 667), (375, 812), (390, 844), (393, 852), (430, 932)]
        let states = [("verified", ""), ("pending", "purchasePending"), ("pending", "verificationPending"),
            ("failed", "productUnavailable"), ("failed", "paymentsDisabled"), ("cancelled", "purchaseCancelled")]
        var snapshots: [String: Any] = [:]
        let root = window!.rootViewController!
        for (width, height) in sizes {
            let page = URL(string: "http://127.0.0.1:9/fixture")!
            let socket = URL(string: "ws://127.0.0.1:9/fixture")!
            let configuration = YalovyBConnection(pageURL: page, channel: "fixture", socketURL: socket)
            let controller = BirthdayKeepsake(configuration: configuration, manual: true, webView: nil, fallback: {}, reconnect: {})
            root.addChild(controller)
            controller.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            root.view.addSubview(controller.view)
            controller.didMove(toParent: root)
            controller.viewDidAppear(false)
            var fixtureSession: MonthlyPlanner?
            for value in Mirror(reflecting: controller).children.map(\.value) {
                if let webView = value as? WKWebView { webView.stopLoading() }
                if let session = value as? MonthlyPlanner {
                    session.stop()
                    fixtureSession = session
                }
            }
            controller.view.layoutIfNeeded()
            let loading = descendants(controller.view).first { $0 is SunshineOuting }!
            snapshots["\(width)x\(height)-loading"] = snapshot(controller.view, views: descendants(loading))
            verifyIncomingPayment(fixtureSession!, controller: controller)
            for (status, reason) in states {
                let message = "Purchase state fixture with enough text to wrap on a small iPhone screen."
                let payload: [String: Any] = ["event": "payResult", "callbackResult": "fixture-\(status)-\(reason)",
                    "productId": "fixture-product", "status": status, "success": status == "verified", "message": message, "reason": reason]
                precondition(SeasonalKeepsake.crystalDreamCanvas.crystalExpressionCanvas?("fixture", payload) == true)
                controller.view.layoutIfNeeded()
                let toast = descendants(controller.view).first { $0.accessibilityIdentifier == purchaseAccessibilityID }!
                snapshots["\(width)x\(height)-\(status)-\(reason)"] = snapshot(controller.view, views: descendants(toast))
                for view in descendants(toast) where view is UILabel {
                    let frame = view.convert(view.bounds, to: controller.view)
                    precondition(frame.minX >= -0.01 && frame.maxX <= CGFloat(width) + 0.01, "horizontal text overflow")
                    precondition(!view.hasAmbiguousLayout, "ambiguous label layout")
                }
                if width == 393 && status == "verified" {
                    let renderer = UIGraphicsImageRenderer(bounds: controller.view.bounds)
                    let image = renderer.image { _ in controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true) }
                    try! image.pngData()!.write(to: output("native-payment.png"))
                }
            }
            controller.gentleExpressionBeacon()
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
        }
        let result = try! JSONSerialization.data(withJSONObject: snapshots, options: [.sortedKeys, .prettyPrinted])
        print("UIKit fixture snapshots passed: \(snapshots.count)")
        fflush(stdout)
        try! result.write(to: output("layout-results.json"))
    }
    private func output(_ name: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(name)
    }
}
