//
//  ProfileViewController.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var profileHeaderView = ProfileHeaderView()
    
    private lazy var quickActionsView: QuickActionsView = {
        let actionItems = [
            ("person.fill", NSLocalizedString("edit_profile", comment: "Edit profile quick action")),
            ("lock.fill", NSLocalizedString("security_settings", comment: "Security settings quick action")),
            ("bell.fill", NSLocalizedString("notifications", comment: "Notifications quick action"))
        ]
        let view = QuickActionsView(actionItems: actionItems)
        view.delegate = self
        return view
    }()
    
    private lazy var settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("logout", comment: "Logout button"), for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = theme.backgroundColor
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = theme.borderColor.cgColor
        
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return button
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLoginStatus()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = theme.backgroundColor
        title = NSLocalizedString("profile", comment: "Profile tab title")
        
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加内容视图
        contentView.addSubview(profileHeaderView)
        contentView.addSubview(quickActionsView)
        contentView.addSubview(settingsStackView)
        
        // 设置设置项
        setupSettingsSections()
        
        // 设置约束
        setupConstraints()
    }
    
    private func setupSettingsSections() {
        // 账户设置
        let accountSection = SettingsSectionView(
            icon: "person.circle.fill",
            title: NSLocalizedString("account_settings", comment: "Account settings section title"),
            items: [
                (NSLocalizedString("personal_info", comment: "Personal info setting"), nil, nil),
                (NSLocalizedString("password_security", comment: "Password and security setting"), nil, nil),
                (NSLocalizedString("linked_accounts", comment: "Linked accounts setting"), nil, nil)
            ]
        )
        accountSection.delegate = self
        
        // 订阅与支付
        let billingSection = SettingsSectionView(
            icon: "creditcard.fill",
            title: NSLocalizedString("subscription_payment", comment: "Subscription and payment section title"),
            items: [
                (NSLocalizedString("subscription_plan", comment: "Subscription plan setting"), NSLocalizedString("premium", comment: "Premium subscription"), nil),
                (NSLocalizedString("payment_methods", comment: "Payment methods setting"), nil, nil),
                (NSLocalizedString("billing_history", comment: "Billing history setting"), nil, nil)
            ]
        )
        billingSection.delegate = self
        
        // 偏好设置
        let preferencesSection = SettingsSectionView(
            icon: "gearshape.fill",
            title: NSLocalizedString("preferences", comment: "Preferences section title"),
            items: [
                (NSLocalizedString("language", comment: "Language setting"), NSLocalizedString("chinese_simplified", comment: "Chinese Simplified language"), nil),
                (NSLocalizedString("dark_mode", comment: "Dark mode setting"), nil, true)
            ]
        )
        preferencesSection.delegate = self
        
        // 添加到主堆栈视图
        settingsStackView.addArrangedSubview(accountSection)
        settingsStackView.addArrangedSubview(billingSection)
        settingsStackView.addArrangedSubview(preferencesSection)
        
        // 添加间隔和退出登录按钮
        settingsStackView.addArrangedSubview(UIView())
        settingsStackView.addArrangedSubview(logoutButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        profileHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        quickActionsView.snp.makeConstraints { make in
            make.top.equalTo(profileHeaderView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }
        
        settingsStackView.snp.makeConstraints { make in
            make.top.equalTo(quickActionsView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    // MARK: - Actions
    private func setupActions() {
        profileHeaderView.editProfileImageButton.addTarget(self, action: #selector(editProfileImageTapped), for: .touchUpInside)
        
        // 添加点击头像区域的手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileHeaderTapped))
        profileHeaderView.addGestureRecognizer(tapGesture)
        profileHeaderView.isUserInteractionEnabled = true
    }
    
    // 修改 editProfileImageTapped 方法
    @objc private func editProfileImageTapped() {
        if !DefaultsManager.shared.getIsLoggedIn() {
            presentLoginViewController()
            return
        }        
    }

    @objc private func profileHeaderTapped() {
        if !DefaultsManager.shared.getIsLoggedIn() {
            presentLoginViewController()
        }
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: NSLocalizedString("confirm_logout", comment: "Confirm logout title"),
            message: NSLocalizedString("confirm_logout_message", comment: "Confirm logout message"),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel button"), style: .cancel)
        let logoutAction = UIAlertAction(title: NSLocalizedString("logout", comment: "Logout button"), style: .destructive) { _ in
            self.logout()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Helper Methods
    private func checkLoginStatus() {
        if DefaultsManager.shared.getIsLoggedIn() {
            // 用户已登录，显示个人资料
            loadUserProfile()
        } else {
            // 用户未登录，显示默认状态
            profileHeaderView.resetToDefault()
        }
    }
    
    private func presentLoginViewController() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    private func loadUserProfile() {
        // 先尝试加载本地缓存的用户信息
        if let cachedUser = DefaultsManager.shared.getUserInfo() {
            // 使用缓存数据更新UI
            profileHeaderView.updateProfile(name: cachedUser.username, email: cachedUser.email, image: nil)
        }
        
        // 然后从服务器获取最新的用户信息（不显示加载指示器）
        UserService.shared.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    // 更新头部视图显示最新的用户信息
                    self.profileHeaderView.updateProfile(name: user.username, email: user.email, image: nil)
                    
                    // 如果有头像URL，加载头像
                    // 这里使用一个默认头像，实际项目中应该从用户数据中获取头像URL
                    if let url = URL(string: "https://ai-public.mastergo.com/ai/img_res/60f7774f5fc2c83de43ec8c4fb745e48.jpg") {
                        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self?.profileHeaderView.profileImageView.image = image
                                }
                            }
                        }.resume()
                    }
                    
                case .failure(let error):
                    // 静默处理错误，因为我们已经显示了缓存数据
                    print("获取用户信息失败: \(error.localizedDescription)")
                    
                    // 如果没有缓存数据且获取失败，则显示默认状态
                    if DefaultsManager.shared.getUserInfo() == nil {
                        self.profileHeaderView.resetToDefault()
                    }
                }
            }
        }
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func logout() {
        // 调用UserService的退出登录方法
        UserService.shared.logout { [weak self] success in
            guard let self = self else { return }
            
            if success {
                // 重置UI
                self.checkLoginStatus()
                
                // 显示退出成功提示
                self.showToast(message: NSLocalizedString("logout_success", comment: "Logout success message"))
                
                // 弹出登录页面
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.presentLoginViewController()
                }
            } else {
                // 显示退出失败提示
                self.showToast(message: NSLocalizedString("logout_failed", comment: "Logout failed message"))
            }
        }
    }
    
    // 添加一个简单的Toast提示方法
    private func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.lessThanOrEqualTo(300)
            make.height.greaterThanOrEqualTo(40)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        })
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileHeaderView.profileImageView.image = editedImage
            // 上传头像到服务器
            uploadProfileImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileHeaderView.profileImageView.image = originalImage
            // 上传头像到服务器
            uploadProfileImage(originalImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    private func uploadProfileImage(_ image: UIImage) {
        // 实现头像上传逻辑
        print("上传头像")
    }
}

// MARK: - QuickActionsViewDelegate
extension ProfileViewController: QuickActionsViewDelegate {
    func quickActionTapped(at index: Int) {
        if !DefaultsManager.shared.getIsLoggedIn() {
            presentLoginViewController()
            return
        }
        
        switch index {
        case 0: // 编辑资料
            print("编辑资料")
        case 1: // 安全设置
            print("安全设置")
        case 2: // 通知
            print("通知")
        default:
            break
        }
    }
}

// MARK: - SettingsSectionViewDelegate
extension ProfileViewController: SettingsSectionViewDelegate {
    func settingItemTapped(title: String) {
        if !DefaultsManager.shared.getIsLoggedIn() {
            presentLoginViewController()
            return
        }
        
        print("设置项点击: \(title)")
    }
}
