//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Pavel Maal on 20.11.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let navigationVC = UINavigationController(rootViewController: ToDoListViewController())
        navigationVC.navigationBar.prefersLargeTitles = true
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 41.0),
        ]

        window?.windowScene = scene
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }
}

