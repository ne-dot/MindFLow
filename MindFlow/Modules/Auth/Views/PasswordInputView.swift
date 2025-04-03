//
//  PasswordInputView.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit
import SnapKit

class PasswordInputView: UIView {
    
    // MARK: - 属性
    var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var placeholder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    var isSecureTextEntry: Bool {
        get { return textField.isSecureTextEntry }
        set { 
            textField.isSecureTextEntry = newValue
            updateToggleButtonImage()
        }
    }
    
    // MARK: - UI组件
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = theme.textColor
        textField.isSecureTextEntry = true
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        button.tintColor = theme.secondaryTextColor
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        backgroundColor = theme.secondaryBackgroundColor
        layer.cornerRadius = 4
        
        addSubview(textField)
        addSubview(toggleButton)
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(toggleButton.snp.leading).offset(-8)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
    }
    
    // MARK: - 事件处理
    @objc private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        updateToggleButtonImage()
    }
    
    private func updateToggleButtonImage() {
        let imageName = textField.isSecureTextEntry ? "eye.circle" : "eye.slash.circle"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
