//
//  SceneDelegate.swift
//  EmTest
//
//  Created by Даниил  on 03.02.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let todoListVC = TodoListRouter.createModule()
        let navigationController = UINavigationController(rootViewController: todoListVC)

        configureNavigationBarAppearance(for: navigationController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    private func configureNavigationBarAppearance(for navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.NavigationBar.background
        appearance.titleTextAttributes = [.foregroundColor: AppColors.NavigationBar.title]
        appearance.largeTitleTextAttributes = [.foregroundColor: AppColors.NavigationBar.title]

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.tintColor = AppColors.NavigationBar.tint
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataStack.shared.saveContext()
    }
}
