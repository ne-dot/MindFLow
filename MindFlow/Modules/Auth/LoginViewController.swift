//
//  LoginViewController.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    // MARK: - UI组件
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(weight: .regular)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: symbolConfig), for: .normal)
        button.tintColor = theme.textColor
        return button
    }()
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "MindFlow"
        label.font = UIFont(name: "Pacifico-Regular", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = theme.primaryColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("welcome_back", comment: "Welcome back message")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var googleButton = SocialLoginButton(icon: "g.circle", title: "continue_with_google")
    private lazy var appleButton = SocialLoginButton(icon: "apple.logo", title: "continue_with_apple")
    private lazy var dividerView = DividerView(text: NSLocalizedString("or", comment: "Or divider"))
    private lazy var loginFormView: LoginFormView = {
        let formView = LoginFormView()
        formView.delegate = self
        return formView
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("enter_email", comment: "Email placeholder")
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = theme.secondaryBackgroundColor
        textField.textColor = theme.textColor
        textField.layer.cornerRadius = 4
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
    
        
        return textField
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("forgot_password", comment: "Forgot password button"), for: .normal)
        button.setTitleColor(theme.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("sign_in", comment: "Sign in button"), for: .normal)
        button.setTitleColor(theme.buttonTextColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = theme.primaryColor
        button.layer.cornerRadius = 4
        return button
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("no_account", comment: "Don't have an account text")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("sign_up", comment: "Sign up button"), for: .normal)
        button.setTitleColor(theme.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    private lazy var signUpStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        view.backgroundColor = theme.backgroundColor
        
        // 添加关闭按钮
        view.addSubview(closeButton)
        
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [logoLabel, welcomeLabel, googleButton, appleButton, dividerView, 
         loginFormView, signUpStackView].forEach {
            contentView.addSubview($0)
        }
        
        // 使用SnapKit设置约束
        setupConstraints()
    }
    
    // 修改约束设置
    private func setupConstraints() {
        // 关闭按钮约束
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(30)
        }
        
        // 滚动视图约束
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        // Logo和欢迎文本约束
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(60)
            make.centerX.equalToSuperview()
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // 社交登录按钮约束
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(48)
        }
        
        appleButton.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(48)
        }
        
        // 分隔线约束
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(appleButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(20)
        }
        
        // 表单约束
        loginFormView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        signUpStackView.snp.makeConstraints { make in
            make.top.equalTo(loginFormView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
        }
    }
    
    // MARK: - 事件处理
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
        appleButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func googleSignInTapped() {
        // 实现Google登录
        print("Google登录被点击")
    }
    
    @objc private func appleSignInTapped() {
        // 实现Apple登录
        print("Apple登录被点击")
    }
    
    
    // 获取用户信息
    private func fetchUserInfo() {
        UserService.shared.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // 移除加载指示器
                LoadingView.hide()
                
                switch result {
                case .success(let user):
                    ToastView.showSuccess(message: "欢迎回来，\(user.username)")
                    // 登录成功后跳转到主界面
                    self.navigateToMainScreen()
                case .failure(let error):
                    ErrorHandler.handleError(error)
                }
            }
        }
    }
    
    @objc private func signUpTapped() {
        // 实现注册功能
        print("注册按钮被点击")
    }
    
    // MARK: - 辅助方法
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToMainScreen() {
        // 跳转到主界面
        dismiss(animated: true)
    }
}

// 添加LoginFormViewDelegate扩展
extension LoginViewController: LoginFormViewDelegate {
    func loginFormView(_ formView: LoginFormView, didTapSignInWith email: String, password: String) {
        // 显示加载指示器
        LoadingView.show(in: view, message: "正在登录...")
        
        // 调用登录接口
        UserService.shared.login(usernameOrEmail: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                // 登录成功后获取用户信息
                self.fetchUserInfo()
            case .failure(let error):
                DispatchQueue.main.async {
                    // 移除加载指示器
                    LoadingView.hide()
                    ErrorHandler.handleError(error)
                }
            }
        }
    }
    
    func loginFormViewDidTapForgotPassword(_ formView: LoginFormView) {
        // 实现忘记密码功能
        print("忘记密码被点击")
    }
}
