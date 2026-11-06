import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ sceneComposition: UIScene,
        willConnectTo growthChronicle: UISceneSession,
        options companionAttachment: UIScene.ConnectionOptions
    ) {
        _ = growthChronicle
        _ = companionAttachment
        guard let seasonalPortrait = sceneComposition as? UIWindowScene else { return }

        let geckoEcdysis = UIWindow(windowScene: seasonalPortrait)
        geckoEcdysis.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        geckoEcdysis.rootViewController = GrowthJournalPigMastication()
        self.window = geckoEcdysis
        geckoEcdysis.makeKeyAndVisible()
    }
}
