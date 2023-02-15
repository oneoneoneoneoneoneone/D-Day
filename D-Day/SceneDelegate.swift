//
//  SceneDelegate.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
//    var rootViewModel = MainViewModel()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let rootViewController = MainViewController()
//        rootViewController.bind(rootViewModel)
        
        let rootNavigationViewController = UINavigationController(rootViewController: rootViewController)
        
        self.window?.rootViewController = rootNavigationViewController
        self.window?.makeKeyAndVisible()
    }
    
}

