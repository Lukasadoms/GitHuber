//
//  SceneDelegate.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let nc = UINavigationController()
        
        let dependencyContainer = DependencyContainer()
        coordinator = MainCoordinator(controller: nc, viewControllersFactory: dependencyContainer)
        coordinator?.start()

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        try? CoreDataManager.saveContext()
    }


}

