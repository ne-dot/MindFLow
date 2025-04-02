//
//  SuggestionCardView.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit

class SuggestionCardView: UIView {
    
    // MARK: - UI Components
    private let textLabel = UILabel()
    private let arrowIcon = UIImageView()
    
    // MARK: - Properties
    var onTap: (() -> Void)?
    
    // MARK: - Initialization
    init(text: String) {
        super.init(frame: .zero)
        setupUI()
        textLabel.text = text
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
        
        // 添加手势识别
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        // 设置标签
        textLabel.textColor = theme.secondaryTextColor
        textLabel.font = UIFont.systemFont(ofSize: 16)
        
        // 设置箭头图标
        arrowIcon.image = UIImage(systemName: "arrow.right")
        arrowIcon.tintColor = theme.textColor
        
        addSubview(textLabel)
        addSubview(arrowIcon)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        textLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(arrowIcon.snp.left).offset(-8)
        }
        
        arrowIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    // MARK: - Actions
    @objc private func cardTapped() {
        onTap?()
    }
}
