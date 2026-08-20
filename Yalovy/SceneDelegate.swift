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

        let portraitComposition = UIWindow(windowScene: seasonalPortrait)
        portraitComposition.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        portraitComposition.rootViewController = GrowthJournal()
        self.window = portraitComposition
        portraitComposition.makeKeyAndVisible()
    }
}
