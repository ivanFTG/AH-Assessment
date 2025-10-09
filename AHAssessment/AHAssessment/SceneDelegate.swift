import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(resource: .appPrimary)
        ]

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance

        let window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController()
        let coordinator = Coordinator(navigationController: navigationController)
        coordinator.start()
        window.rootViewController = coordinator.navigationController

        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
