import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ yalovyApplication: UIApplication,
        didFinishLaunchingWithOptions openingContext: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        _ = yalovyApplication
        _ = openingContext
        YalovyKeepsakeRecordKeeper.yalovyKeeper.beginRecordTrail()
        return true
    }

    func application(
        _ yalovyApplication: UIApplication,
        configurationForConnecting incomingScene: UISceneSession,
        options sceneTraits: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        _ = yalovyApplication
        _ = sceneTraits
        let yalovyScenePlan = UISceneConfiguration(
            name: "Yalovy Pet Journal",
            sessionRole: incomingScene.role
        )
        yalovyScenePlan.delegateClass = SceneDelegate.self
        return yalovyScenePlan
    }
}

final class YalovyKeepsakeRecordKeeper {
    static let yalovyKeeper = YalovyKeepsakeRecordKeeper()

    private var recordTrailTask: Task<Void, Never>?

    private init() {}

    func beginRecordTrail() {
        guard recordTrailTask == nil else { return }

        recordTrailTask = Task.detached(priority: .background) {
            for await signedEntry in Transaction.updates {
                guard case .verified(let trustedRecord) = signedEntry else {
                    continue
                }

                await MainActor.run {
                    NotificationCenter.default.post(
                        name: .yalovyKeepsakeRecordArrived,
                        object: trustedRecord
                    )
                }
            }
        }
    }
}

extension Notification.Name {
    static let yalovyKeepsakeRecordArrived = Notification.Name("YalovyKeepsakeRecordArrived")
}
