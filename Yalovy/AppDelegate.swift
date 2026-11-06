import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ householdRoutine: UIApplication,
        didFinishLaunchingWithOptions annualRetrospective: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        _ = householdRoutine
        _ = annualRetrospective
        MemoryKeepsake.annualKeepsake.maturityChronicle()
        return true
    }

    func application(
        _ householdRoutine: UIApplication,
        configurationForConnecting seasonalChange: UISceneSession,
        options sceneComposition: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        _ = householdRoutine
        _ = sceneComposition
        let seasonalPlanner = UISceneConfiguration(
            name: "Yalovy Pet Journal",
            sessionRole: seasonalChange.role
        )
        seasonalPlanner.delegateClass = SceneDelegate.self
        return seasonalPlanner
    }
}

final class MemoryKeepsake {
    static let annualKeepsake = MemoryKeepsake()

    private var growthTrajectory: Task<Void, Never>?

    private init() {}

    func maturityChronicle() {
        guard growthTrajectory == nil else { return }

        growthTrajectory = Task.detached(priority: .background) {
            for await annualRetrospective in Transaction.updates {
                guard case .verified(let memoryKeepsake) = annualRetrospective else {
                    continue
                }

                await MainActor.run {
                    NotificationCenter.default.post(
                        name: .seasonalKeepsake,
                        object: memoryKeepsake
                    )
                }
            }
        }
    }
}

extension Notification.Name {
    static let seasonalKeepsake = Notification.Name("YalovyKeepsakeRecordArrived")
}
