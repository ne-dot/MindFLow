//
//  SceneDelegate.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        // 执行匿名登录
        performAnonymousLogin()
    }
    
    // 执行匿名登录
    private func performAnonymousLogin() {
        // 检查是否已有匿名ID
        if let existingAnonymousId = DefaultsManager.shared.getAnonymousId() {
            // 已有匿名ID，直接设置到NetworkManager
            NetworkManager.shared.setAnonymousId(existingAnonymousId)
            print("已使用现有匿名ID: \(existingAnonymousId)")
        } else {
            // 没有匿名ID，调用登录接口
            UserService.shared.anonymousLogin { result in
                switch result {
                case .success(let data):
                    print("anonymous_login_success".localized + ", " + "user_id".localized + ": \(data.user.userId)")
                    // 匿名ID已在UserService中保存
                case .failure(let error):
                    print("anonymous_login_failure".localized + ": \(error.localizedDescription)")
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

