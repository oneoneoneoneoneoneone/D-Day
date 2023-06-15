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
        
        self.window?.backgroundColor = .systemBackground
        self.window?.rootViewController = rootNavigationViewController
        self.window?.makeKeyAndVisible()
        self.window?.overrideUserInterfaceStyle = UserDefaultsManager().getIsDarkMode() ? .dark : .unspecified
        
        //위젯 open 확인
        guard let urlInfo = connectionOptions.urlContexts.first else {return}
        openDetailView(url: urlInfo.url)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url{
            openDetailView(url: url)
        }
    }
    
    ///위젯 widgetURL에서 전달받은 id 값으로 detailView 화면 열기
    func openDetailView(url: URL){
        if url.absoluteString.starts(with: "open://detail?"){
            guard let urlComponents = URLComponents(string: url.absoluteString),
                  let id = urlComponents.queryItems?.first(where: { $0.name == "id" })?.value else {
                      return
                  }

            let detailViewController = DetailViewController(id: id)

            let nv = self.window?.rootViewController as? UINavigationController
            nv?.popViewController(animated: true)
            nv?.pushViewController(detailViewController, animated: true)
        }
    }
    
}

