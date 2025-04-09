//
//  AIResponseCardView.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit
import Down // 添加Down库的导入

class AIResponseCardView: UITableViewCell {
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.backgroundColor
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "brain")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = theme.primaryColor
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MindFlow AI"
        label.textColor = theme.textColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var responseTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = theme.secondaryTextColor
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private lazy var actionButtonsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "doc.on.doc")
        button.setImage(image, for: .normal)
        button.tintColor = theme.secondaryTextColor
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.arrow.up")
        button.setImage(image, for: .normal)
        button.tintColor = theme.secondaryTextColor
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart")
        button.setImage(image, for: .normal)
        button.tintColor = theme.secondaryTextColor
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private var isLiked: Bool = false
    private var isDisliked: Bool = false
    private var markdownText: String = "" // 存储原始Markdown文本
    private var isFavorited: Bool = false {
        didSet {
            updateFavoriteButtonState()
        }
    }
    
    // 回调闭包
    var onCopy: (() -> Void)?
    var onShare: (() -> Void)?
    var onLike: ((Bool) -> Void)?
    var onDislike: ((Bool) -> Void)?
    var onFavorite: ((Bool) -> Void)?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Configuration
    func configure(with response: String, isLiked: Bool = false, isDisliked: Bool = false) {
        self.isLiked = isLiked
        self.isDisliked = isDisliked
        self.markdownText = response
        
        // 将Markdown转换为AttributedString
        renderMarkdown(response)
    }
    
    // 添加Markdown渲染方法
    func renderMarkdown(_ markdown: String) {
        let down = Down(markdownString: markdown)
        if let attributedString = try? down.toAttributedString([.hardBreaks, .unsafe]) {
            // 应用基本样式
            let mutableAttrString = NSMutableAttributedString(attributedString: attributedString)
            
            // 设置默认字体和颜色
            let range = NSRange(location: 0, length: mutableAttrString.length)
            mutableAttrString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: range)
            mutableAttrString.addAttribute(.foregroundColor, value: theme.secondaryTextColor, range: range)
            
            // 设置标题样式
            mutableAttrString.enumerateAttribute(.font, in: range, options: []) { (value, range, _) in
                if let font = value as? UIFont {
                    if font.pointSize > 15 { // 标题字体通常更大
                        mutableAttrString.addAttribute(.foregroundColor, value: theme.textColor, range: range)
                        mutableAttrString.addAttribute(.font, value: UIFont.systemFont(ofSize: font.pointSize, weight: .semibold), range: range)
                    }
                }
            }
            
            // 设置链接样式
            mutableAttrString.enumerateAttribute(.link, in: range, options: []) { (value, range, _) in
                if value != nil {
                    mutableAttrString.addAttribute(.foregroundColor, value: UIColor(red: 0.31, green: 0.27, blue: 0.9, alpha: 1.0), range: range)
                }
            }
            
            responseTextView.attributedText = mutableAttrString
        } else {
            // 如果转换失败，显示纯文本
            responseTextView.text = markdown
            print("Markdown渲染失败")
        }
        
        setNeedsLayout()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // 容器视图
        containerView.backgroundColor = theme.backgroundColor
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        // 添加阴影效果
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        // 头像
        avatarImageView.image = UIImage(named: "ai_avatar") ?? UIImage(systemName: "brain")
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.tintColor = UIColor(red: 0.31, green: 0.27, blue: 0.9, alpha: 1.0)
        avatarImageView.backgroundColor = theme.secondaryTextColor
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        
        // 标题
        titleLabel.text = "MindFlow AI"
        titleLabel.textColor = theme.textColor
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        // 回复文本
        responseTextView.backgroundColor = .clear
        responseTextView.textColor = theme.secondaryTextColor
        responseTextView.font = UIFont.systemFont(ofSize: 15)
        responseTextView.isEditable = false
        responseTextView.isScrollEnabled = false
        responseTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        responseTextView.textContainer.lineFragmentPadding = 0
        
        // 操作按钮容器
        actionButtonsView.backgroundColor = theme.backgroundColor
        actionButtonsView.layer.cornerRadius = 8
        
        
        // 添加子视图
        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(responseTextView)
        containerView.addSubview(actionButtonsView)
        
        actionButtonsView.addSubview(copyButton)
        actionButtonsView.addSubview(shareButton)
        actionButtonsView.addSubview(favoriteButton)
        
        setupConstraints()
    }

    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.centerY.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(-16)
        }
        
        responseTextView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        actionButtonsView.snp.makeConstraints { make in
            make.top.equalTo(responseTextView.snp.bottom).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(44)
            make.width.equalTo(44 * 3)
        }
        
        copyButton.snp.makeConstraints { make in
            make.right.equalTo(shareButton.snp.left).offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        shareButton.snp.makeConstraints { make in
            make.right.equalTo(favoriteButton.snp.left).offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
    }
    
    // MARK: - Actions
    @objc private func copyButtonTapped() {
        // 添加动画效果
        animateButton(copyButton)
        onCopy?()
    }
    
    @objc private func shareButtonTapped() {
        // 添加动画效果
        animateButton(shareButton)
        onShare?()
    }
    
    @objc private func favoriteButtonTapped() {
        isFavorited.toggle()
        // 添加动画效果
        animateButton(favoriteButton)
        // 触发回调
        onFavorite?(isFavorited)
    }
    
    // 更新收藏按钮状态
    private func updateFavoriteButtonState() {
        let imageName = isFavorited ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = isFavorited ? theme.primaryColor : theme.secondaryTextColor
    }
    
    // 公开方法设置收藏状态
    func setFavorited(_ favorited: Bool) {
        isFavorited = favorited
    }
    
    // MARK: - Private Methods
    private func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        }
    }
}
