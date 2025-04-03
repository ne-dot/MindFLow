//
//  SocialLoginButton.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit
import SnapKit

class SocialLoginButton: UIButton {
    
    // MARK: - 初始化方法
    init(icon: String, title: String) {
        super.init(frame: .zero)
        setupButton(icon: icon, title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - 私有方法
    private func setupButton(icon: String, title: String) {
        backgroundColor = theme.backgroundColor
        layer.borderWidth = 1
        layer.borderColor = theme.borderColor.cgColor
        layer.cornerRadius = 4
        
        // 创建自定义内容视图
        let contentView = UIStackView()
        contentView.axis = .horizontal
        contentView.alignment = .center
        contentView.spacing = 8
        addSubview(contentView)
        
        // 创建图标
        let symbolConfig = UIImage.SymbolConfiguration(weight: .regular)
        let iconView = UIImageView(image: UIImage(systemName: icon, withConfiguration: symbolConfig))
        
        // 创建文字标签
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString(title, comment: "")
        titleLabel.textColor = theme.textColor
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        // 添加到内容视图
        contentView.addArrangedSubview(iconView)
        contentView.addArrangedSubview(titleLabel)
        
        // 设置约束
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
