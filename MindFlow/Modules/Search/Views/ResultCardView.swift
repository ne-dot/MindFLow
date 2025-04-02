//
//  ResultCardView.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit
import Kingfisher

class ResultCardView: UITableViewCell {
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.secondaryBackgroundColor
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = theme.textColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private var isFavorited: Bool = false
    private var isBookmarked: Bool = false
    private var hasImage: Bool = false
    
    // 回调闭包
    var onFavorite: ((Bool) -> Void)?
    var onBookmark: ((Bool) -> Void)?
    var onClose: (() -> Void)?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBaseUI()
    }
    
    // MARK: - Configuration
    func configure(with image: String? = nil, title: String, description: String, source: String, isFavorited: Bool, isBookmarked: Bool) {
        self.isFavorited = isFavorited
        self.isBookmarked = isBookmarked
        self.hasImage = image != nil
        
        titleLabel.text = title
        descriptionLabel.text = description
        sourceLabel.text = source
        
        // 设置图片（如果有）
        if let imageUrlString = image, let imageUrl = URL(string: imageUrlString) {
            cardImageView.kf.setImage(with: imageUrl)
            cardImageView.isHidden = false
        } else {
            cardImageView.isHidden = true
        }
        
        updateFavoriteButton()
        updateBookmarkButton()
        updateConstraints(hasImage: self.hasImage)
    }
    
    // MARK: - UI Setup
    private func setupBaseUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // 添加阴影效果
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        // 添加子视图
        contentView.addSubview(containerView)
        containerView.addSubview(cardImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(sourceLabel)
        containerView.addSubview(favoriteButton)
        containerView.addSubview(bookmarkButton)
        
        // 设置基础约束
        setupBaseConstraints()
    }
    
    private func setupBaseConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.right.equalTo(bookmarkButton.snp.left).offset(-16)
            make.width.height.equalTo(32)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(32)
        }
    }
    
    private func updateConstraints(hasImage: Bool) {
        // 移除之前的约束
        titleLabel.snp.removeConstraints()
        descriptionLabel.snp.removeConstraints()
        sourceLabel.snp.removeConstraints()
        favoriteButton.snp.removeConstraints()
        bookmarkButton.snp.removeConstraints()
        
        if hasImage {
            cardImageView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(180)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(cardImageView.snp.bottom).offset(12)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            }
        } else {
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            }
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(sourceLabel)
            make.right.equalTo(bookmarkButton.snp.left).offset(-16)
            make.width.height.equalTo(32)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(sourceLabel)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(32)
        }
    }
    
    private func updateFavoriteButton() {
        let imageName = isFavorited ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorited ? UIColor(red: 0.31, green: 0.27, blue: 0.9, alpha: 1.0) : .gray
    }
    
    private func updateBookmarkButton() {
        let imageName = isBookmarked ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
        bookmarkButton.tintColor = isBookmarked ? UIColor(red: 0.31, green: 0.27, blue: 0.9, alpha: 1.0) : .gray
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        isFavorited.toggle()
        updateFavoriteButton()
        onFavorite?(isFavorited)
        
        // 添加触觉反馈
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    @objc private func bookmarkButtonTapped() {
        isBookmarked.toggle()
        updateBookmarkButton()
        onBookmark?(isBookmarked)
        
        // 添加触觉反馈
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // MARK: - Cell Highlight
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if animated {
            UIView.animate(withDuration: 0.1) {
                self.containerView.transform = highlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            }
        } else {
            containerView.transform = highlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
        }
    }
}
