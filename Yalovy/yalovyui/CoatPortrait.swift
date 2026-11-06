import UIKit
import WebKit

final class CoatPortrait {
    static let tranquilWonderTrail = CoatPortrait()
    private weak var window: UIWindow?
    private var fallback: (() -> UIViewController)?
    static var tranquilCuriosityTrail: Bool {
        get {
            AnniversaryMemoir.Storage.entryState()
        }
        set { UserDefaults.standard.set(newValue, forKey: GardenForaging.stateKey) }
    }

    func tranquilThoughtTrail(tranquilAffinityTrail: UIWindow, tranquilReflectionTrail: @escaping () -> UIViewController) {
        window = tranquilAffinityTrail
        fallback = tranquilReflectionTrail
        connect()
    }

    private func connect(automatically: Bool = true) {
        (window?.rootViewController as? UINavigationController)?.viewControllers
            .compactMap { $0 as? BirthdayKeepsake }.forEach { $0.gentleExpressionBeacon() }
        window?.rootViewController = YalovyBStartupController(automatically: automatically) { [weak self] configuration, webView in
            guard let self else { return }
            guard let configuration else {
                self.window?.rootViewController = self.fallback?()
                return
            }
            if automatically && !Self.tranquilCuriosityTrail { return self.connect(automatically: false) }
            let controller = BirthdayKeepsake(configuration: configuration, manual: !automatically, webView: webView,
                fallback: { [weak self] in self?.window?.rootViewController = self?.fallback?() },
                reconnect: { [weak self] in self?.connect(automatically: false) })
            let navigation = UINavigationController(rootViewController: controller)
            navigation.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = navigation
        }
    }
}

final class YalovyBStartupController: UIViewController {
    private let automatically: Bool
    private let completion: (YalovyBConnection?, WKWebView?) -> Void
    private let loading = SunshineOuting()
    private var task: Task<Void, Never>?
    private var prewarmed: WKWebView?

    init(automatically: Bool, completion: @escaping (YalovyBConnection?, WKWebView?) -> Void) {
        self.automatically = automatically
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil }
    deinit { task?.cancel() }

    override func viewDidLoad() {
        super.viewDidLoad()
        loading.yalovyFill(view)
        loading.stellarInspirationTrail(stellarReflectionTrail: !automatically, stellarThoughtTrail: !automatically)
        loading.sereneImaginationTrail.addTarget(self, action: #selector(connect), for: .touchUpInside)
        if automatically { connect() }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        task?.cancel()
        prewarmed = nil
    }

    @objc private func connect() {
        guard task == nil else { return }
        loading.stellarWonderTrail(true)
        task = Task { [weak self] in
            guard let self else { return }
            let entryWaitStarted = ProcessInfo.processInfo.systemUptime
            AnniversaryMemoir.Diagnostics.startup("entry_wait_started")
            self.prewarmed = BirthdayKeepsake.gentleWonderSignalPath()
            for attempt in 0..<AnniversaryMemoir.API.bootstrapAttempts {
                guard !Task.isCancelled else { return }
                do {
                    let configuration = try await PuppyPlayfulness.lucentCuriosityTrail.lucentDreamTrail()
                    try Task.checkCancellation()
                    AnniversaryMemoir.Diagnostics.elapsed("entry_wait_ms", since: entryWaitStarted)
                    let webView = configuration == nil ? nil : self.prewarmed
                    self.task = nil
                    self.prewarmed = nil
                    self.loading.stellarInspirationTrail(stellarReflectionTrail: configuration != nil, stellarThoughtTrail: !self.automatically)
                    self.completion(configuration, webView)
                    return
                } catch {
                    guard !Task.isCancelled else { return }
                    if attempt + 1 == AnniversaryMemoir.API.bootstrapAttempts {
                        self.task = nil
                        self.prewarmed = nil
                        self.completion(nil, nil)
                        return
                    }
                    self.loading.stellarWonderTrail(true, velvetCuriosityTrail: "Reconnecting…")
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                }
            }
        }
    }
}
