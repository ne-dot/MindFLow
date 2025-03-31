//
//  MainTabBarController.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        // 设置TabBar外观
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // 创建各个Tab的ViewController
        let homeVC = HomeViewController()
        let favoriteVC = FavoritesViewController()
        let exploreVC = ExploreViewController() // 新增探索Tab
        let profileVC = ProfileViewController()
        
        // 设置Tab图标和标题 - 使用SF Symbols
        homeVC.tabBarItem = UITabBarItem(
            title: "首页", 
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        favoriteVC.tabBarItem = UITabBarItem(
            title: "收藏",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        
        exploreVC.tabBarItem = UITabBarItem(
            title: "探索", 
            image: UIImage(systemName: "safari"),
            selectedImage: UIImage(systemName: "safari.fill")
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "我的", 
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        // 设置TabBar的ViewControllers
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: favoriteVC),
            UINavigationController(rootViewController: exploreVC),
            UINavigationController(rootViewController: profileVC)
        ]
    }
}
