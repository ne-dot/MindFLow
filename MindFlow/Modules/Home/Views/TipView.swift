//
//  TipView.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit

class TipView: UIView {
    
    // MARK: - UI Components
    private let tipIcon = UIImageView()
    private let tipLabel = UILabel()
    
    // MARK: - Initialization
    init(iconName: String, text: String) {
        super.init(frame: .zero)
        setupUI()
        tipIcon.image = UIImage(systemName: iconName)
        tipLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = theme.secondaryBackgroundColor
        layer.cornerRadius = 12
        layer.shadowColor = theme.cardShadowColor.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        
        // 设置图标
        tipIcon.tintColor = theme.primaryColor
        
        // 设置标签
        tipLabel.textColor = theme.secondaryTextColor
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(tipIcon)
        addSubview(tipLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tipIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(tipIcon.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
