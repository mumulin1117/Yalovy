import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let lalovyuwindow = UIWindow(windowScene: windowScene)
        lalovyuwindow.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        lalovyuwindow.rootViewController = YalovyPetShellController()
        self.window = lalovyuwindow
        lalovyuwindow.makeKeyAndVisible()
    }
}
