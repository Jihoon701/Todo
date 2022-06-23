//
//  SceneDelegate.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
//        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
//
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene

        Constant.firstTimeLauncing = true

        if Constant.firstTimeLauncing ?? false {
            Constant.firstTimeLauncing = false
            let storyboard = UIStoryboard(name: "WalkThrough", bundle: nil)
            let walkThroughVC = storyboard.instantiateViewController(withIdentifier: "WalkThroughViewController")
            window?.rootViewController = walkThroughVC
        }
        else {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            let nav = UINavigationController(rootViewController: mainVC)
            print("nav")
            print(nav)
            nav.navigationBar.isHidden = true

            window?.rootViewController = nav
        }
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

