//
//  LoginFormView.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit
import SnapKit

protocol LoginFormViewDelegate: AnyObject {
    func loginFormView(_ formView: LoginFormView, didTapSignInWith email: String, password: String)
    func loginFormViewDidTapForgotPassword(_ formView: LoginFormView)
}

class LoginFormView: UIView {
    
    // MARK: - 属性
    weak var delegate: LoginFormViewDelegate?
    
    // MARK: - UI组件
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
    
    private lazy var passwordInputView = PasswordInputView()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("forgot_password", comment: "Forgot password button"), for: .normal)
        button.setTitleColor(theme.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("sign_in", comment: "Sign in button"), for: .normal)
        button.setTitleColor(theme.buttonTextColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = theme.primaryColor
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - 初始化方法
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI设置
    private func setupUI() {
        passwordInputView.placeholder = NSLocalizedString("enter_password", comment: "Password placeholder")
        
        [emailTextField, passwordInputView, forgotPasswordButton, signInButton].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        passwordInputView.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordInputView.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - 事件处理
    @objc private func forgotPasswordTapped() {
        delegate?.loginFormViewDidTapForgotPassword(self)
    }
    
    @objc private func signInTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordInputView.text, !password.isEmpty else {
            // 显示错误提示
            return
        }
        
        delegate?.loginFormView(self, didTapSignInWith: email, password: password)
    }
    
    // MARK: - 公共方法
    func getEmail() -> String? {
        return emailTextField.text
    }
    
    func getPassword() -> String? {
        return passwordInputView.text
    }
}
