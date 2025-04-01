//
//  ProfileViewController.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLoginStatus()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "我的"
    }
    
    private func checkLoginStatus() {
        // 检查用户是否已登录
        if !DefaultsManager.shared.getIsLoggedIn() {
            // 用户未登录，显示登录页面
            presentLoginViewController()
        } else {
            // 用户已登录，显示个人资料
            loadUserProfile()
        }
    }
    
    private func presentLoginViewController() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    private func loadUserProfile() {
        // 加载用户资料
        // 这里实现用户资料的UI和数据加载
    }
}
