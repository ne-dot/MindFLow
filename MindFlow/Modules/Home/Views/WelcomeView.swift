//
//  WelcomeView.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit
import Kingfisher

class WelcomeView: UIView {
    
    // MARK: - UI Components
    private let welcomeImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // 欢迎图片样式
        let imageUrl = URL(string: "https://ai-public.mastergo.com/ai/img_res/2da3e6375e465a981859d8bf399f4a27.jpg")
        welcomeImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "welcome_illustration"))
        welcomeImageView.contentMode = .scaleAspectFill
        welcomeImageView.clipsToBounds = true
        welcomeImageView.layer.cornerRadius = 16
        
        // 标题样式
        titleLabel.text = "welcome_title".localized
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = theme.textColor
        titleLabel.textAlignment = .center
        
        // 副标题样式
        subtitleLabel.text = "welcome_subtitle".localized
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = theme.secondaryTextColor
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        addSubview(welcomeImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // 欢迎图片约束
        welcomeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(256)
        }
        
        // 标题约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        // 副标题约束
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview()
        }
    }
}
