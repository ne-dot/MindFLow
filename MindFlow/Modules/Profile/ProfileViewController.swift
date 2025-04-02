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
    
    private lazy var profileHeaderView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = .systemGray5
        // 设置默认图片或占位图
        imageView.image = UIImage(named: "profile_placeholder")
        return imageView
    }()
    
    private lazy var editProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = theme.primaryColor
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = theme.textColor
        label.textAlignment = .center
        label.text = "未登录"
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.text = "点击登录"
        return label
    }()
    
    private lazy var quickActionsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
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
        
        // 设置个人资料头部
        setupProfileHeader()
        
        // 设置快速操作按钮
        setupQuickActions()
        
        // 设置设置项
        setupSettingsSections()
        
        // 设置约束
        setupConstraints()
    }
    
    private func setupProfileHeader() {
        profileHeaderView.addSubview(profileImageView)
        profileHeaderView.addSubview(editProfileImageButton)
        profileHeaderView.addSubview(nameLabel)
        profileHeaderView.addSubview(emailLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(80)
        }
        
        editProfileImageButton.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom).offset(4)
            make.trailing.equalTo(profileImageView.snp.trailing).offset(4)
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // 将actions定义为类属性
    private let quickActionItems = [
        ("person.fill", "编辑资料"),
        ("lock.fill", "安全设置"),
        ("bell.fill", "通知")
    ]
    
    private func setupQuickActions() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        quickActionsView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        for (index, item) in quickActionItems.enumerated() {
            let button = createActionButton(icon: item.0, title: item.1, tag: index + 100)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createActionButton(icon: String, title: String, tag: Int) -> UIView {
        let container = UIView()
        container.backgroundColor = theme.secondaryBackgroundColor
        container.layer.cornerRadius = 12
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.tintColor = theme.primaryColor
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = theme.textColor
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        container.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionButtonTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.tag = tag
        
        return container
    }
    
    private func setupSettingsSections() {
        // 账户设置
        let accountSection = createSettingsSection(
            icon: "person.circle.fill",
            title: "账户设置",
            items: [
                ("个人信息", nil, nil),
                ("密码与安全", nil, nil),
                ("关联账户", nil, nil)
            ]
        )
        
        // 订阅与支付
        let billingSection = createSettingsSection(
            icon: "creditcard.fill",
            title: "订阅与支付",
            items: [
                ("订阅计划", "高级版", nil),
                ("支付方式", nil, nil),
                ("账单记录", nil, nil)
            ]
        )
        
        // 偏好设置
        let preferencesSection = createSettingsSection(
            icon: "gearshape.fill",
            title: "偏好设置",
            items: [
                ("语言", "简体中文", nil),
                ("深色模式", nil, true)
            ]
        )
        
        // 添加到主堆栈视图
        settingsStackView.addArrangedSubview(accountSection)
        settingsStackView.addArrangedSubview(billingSection)
        settingsStackView.addArrangedSubview(preferencesSection)
        
        // 添加退出登录按钮
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("退出登录", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.backgroundColor = theme.backgroundColor
        logoutButton.layer.cornerRadius = 12
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        logoutButton.layer.masksToBounds = true
        logoutButton.layer.borderWidth = 0.5
        logoutButton.layer.borderColor = theme.borderColor.cgColor
        
        logoutButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        settingsStackView.addArrangedSubview(UIView()) // 添加间隔
        settingsStackView.addArrangedSubview(logoutButton)
    }
    
    private func createSettingsSection(icon: String, title: String, items: [(String, String?, Bool?)]) -> UIView {
        let sectionView = UIView()
        sectionView.backgroundColor = .white
        sectionView.layer.cornerRadius = 12
        sectionView.layer.borderWidth = 0.5
        sectionView.layer.borderColor = theme.borderColor.cgColor
        
        let headerView = UIView()
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.tintColor = theme.primaryColor
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = theme.textColor
        
        headerView.addSubview(iconImageView)
        headerView.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        // 创建项目堆栈
        let itemsStackView = UIStackView()
        itemsStackView.axis = .vertical
        itemsStackView.spacing = 4
        
        for (index, item) in items.enumerated() {
            // 这里可能是问题所在，Swift无法推断nil的类型
            let itemView = createSettingItem(title: item.0, value: item.1, isToggle: item.2 ?? false)
            itemsStackView.addArrangedSubview(itemView)
            
            // 添加分隔线，除了最后一项
            if index < items.count - 1 {
                let separator = UIView()
                separator.backgroundColor = theme.borderColor
                separator.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                }
                itemsStackView.addArrangedSubview(separator)
            }
        }
        
        sectionView.addSubview(headerView)
        sectionView.addSubview(itemsStackView)
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        itemsStackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        return sectionView
    }
    
    private func createSettingItem(title: String, value: String?, isToggle: Bool) -> UIView {
        let itemView = UIView()
        itemView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = theme.textColor
        
        itemView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        if isToggle {
            let toggle = UISwitch()
            toggle.onTintColor = theme.primaryColor
            itemView.addSubview(toggle)
            
            toggle.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        } else {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.alignment = .center
            
            if let value = value {
                let valueLabel = UILabel()
                valueLabel.text = value
                valueLabel.font = UIFont.systemFont(ofSize: 14)
                valueLabel.textColor = value == "高级版" ? theme.primaryColor : .systemGray2
                stackView.addArrangedSubview(valueLabel)
            }
            
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            chevronImageView.tintColor = .systemGray3
            chevronImageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(chevronImageView)
            
            itemView.addSubview(stackView)
            
            stackView.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            chevronImageView.snp.makeConstraints { make in
                make.width.height.equalTo(12)
            }
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(settingItemTapped(_:)))
        itemView.addGestureRecognizer(tapGesture)
        itemView.tag = title.hashValue
        
        return itemView
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
        editProfileImageButton.addTarget(self, action: #selector(editProfileImageTapped), for: .touchUpInside)
        
        // 添加点击头像区域的手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileHeaderTapped))
        profileHeaderView.addGestureRecognizer(tapGesture)
        profileHeaderView.isUserInteractionEnabled = true
    }
    
    @objc private func editProfileImageTapped() {
        if !DefaultsManager.shared.getIsLoggedIn() {
            presentLoginViewController()
            return
        }
        
        // 显示图片选择器
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "拍照", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera)
        }
        
        let libraryAction = UIAlertAction(title: "从相册选择", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    @objc private func profileHeaderTapped() {
        if !DefaultsManager.shared.getIsLoggedIn() {
            presentLoginViewController()
        }
    }
    
    @objc private func actionButtonTapped(_ sender: UITapGestureRecognizer) {
        if !DefaultsManager.shared.getIsLoggedIn() {
            presentLoginViewController()
            return
        }
        
        guard let view = sender.view else { return }
        
        switch view.tag {
        case 100: // 编辑资料
            print("编辑资料")
        case 101: // 安全设置
            print("安全设置")
        case 102: // 通知
            print("通知")
        default:
            break
        }
    }
    
    @objc private func settingItemTapped(_ sender: UITapGestureRecognizer) {
        if !DefaultsManager.shared.getIsLoggedIn() {
            presentLoginViewController()
            return
        }
        
        guard let view = sender.view else { return }
        print("设置项点击: \(view.tag)")
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "确认退出", message: "您确定要退出登录吗？", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        let logoutAction = UIAlertAction(title: "退出", style: .destructive) { _ in
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
            nameLabel.text = "未登录"
            emailLabel.text = "点击登录"
            profileImageView.image = UIImage(named: "profile_placeholder")
        }
    }
    
    private func presentLoginViewController() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    private func loadUserProfile() {
        // 这里应该从API获取用户资料
        // 临时使用假数据
        nameLabel.text = "Sarah Anderson"
        emailLabel.text = "sarah.anderson@gmail.com"
        
        // 加载头像（这里可以使用SDWebImage等库加载网络图片）
        if let url = URL(string: "https://ai-public.mastergo.com/ai/img_res/60f7774f5fc2c83de43ec8c4fb745e48.jpg") {
            // 使用URLSession加载图片（实际项目中建议使用图片加载库）
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                    }
                }
            }.resume()
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
        // 清除用户数据
        DefaultsManager.shared.setIsLoggedIn(false)
        DefaultsManager.shared.setAccessToken(nil)
        DefaultsManager.shared.setRefreshToken(nil)
        
        // 重置UI
        checkLoginStatus()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
            // 上传头像到服务器
            uploadProfileImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
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
