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
    
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // 设置TabBar背景色
        appearance.backgroundColor = theme.secondaryBackgroundColor
        
        // 设置选中和非选中的文字颜色
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: theme.tabBarInactiveTintColor
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: theme.primaryColor
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        // 设置图标颜色
        appearance.stackedLayoutAppearance.normal.iconColor = theme.tabBarInactiveTintColor
        appearance.stackedLayoutAppearance.selected.iconColor = theme.primaryColor
        
        // 应用外观设置
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        // 设置TabBar的tintColor（这会影响选中项的图标颜色）
        tabBar.tintColor = theme.primaryColor
        
        // 创建各个Tab的ViewController
        let homeVC = HomeViewController()
        let favoriteVC = FavoritesViewController()
        let exploreVC = ExploreViewController() // 新增探索Tab
        let profileVC = ProfileViewController()
        
        // 设置Tab图标和标题 - 使用SF Symbols
        homeVC.tabBarItem = UITabBarItem(
            title: "tab_home".localized,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        favoriteVC.tabBarItem = UITabBarItem(
            title: "tab_favorites".localized,
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        
        exploreVC.tabBarItem = UITabBarItem(
            title: "tab_explore".localized, 
            image: UIImage(systemName: "safari"),
            selectedImage: UIImage(systemName: "safari.fill")
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "tab_profile".localized,
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
