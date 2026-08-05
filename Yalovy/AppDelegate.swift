import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        StoreTransactionObserver.shared.start()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

final class StoreTransactionObserver {
    static let shared = StoreTransactionObserver()

    private var updatesTask: Task<Void, Never>?

    private init() {}

    func start() {
        guard updatesTask == nil else { return }

        updatesTask = Task.detached(priority: .background) {
            for await update in Transaction.updates {
                guard case .verified(let transaction) = update else {
                    continue
                }

                await MainActor.run {
                    NotificationCenter.default.post(
                        name: .storeTransactionUpdated,
                        object: transaction
                    )
                }
            }
        }
    }
}

extension Notification.Name {
    static let storeTransactionUpdated = Notification.Name("YalovyStoreTransactionUpdated")
}
