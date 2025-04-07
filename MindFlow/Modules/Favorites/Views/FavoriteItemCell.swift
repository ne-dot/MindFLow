import UIKit
import SnapKit
import Kingfisher

class FavoriteItemCell: UITableViewCell {
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        return stack
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bottomContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var tagsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 16)
        let image = UIImage(systemName: "trash", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray3
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    var onDelete: (() -> Void)?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(thumbnailImageView)
        contentStackView.addArrangedSubview(textStackView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.addArrangedSubview(bottomContainer)
        
        bottomContainer.addSubview(tagsStackView)
        bottomContainer.addSubview(deleteButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        tagsStackView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    // MARK: - Configuration
    func configure(with item: FavoritesViewController.FavoriteItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        
        // 配置图片
        if let imageUrl = item.imageUrl {
            thumbnailImageView.isHidden = false
            thumbnailImageView.kf.setImage(
                with: URL(string: imageUrl),
                placeholder: UIImage(systemName: "photo")
            )
        } else {
            thumbnailImageView.isHidden = true
        }
        
        // 配置标签
        configureTags(item.tags)
    }
    
    private func configureTags(_ tags: [String]) {
        // 清除现有标签
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 添加新标签
        tags.forEach { tag in
            let tagView = createTagView(tag)
            tagsStackView.addArrangedSubview(tagView)
        }
    }
    
    private func createTagView(_ text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = theme.primaryColor.withAlphaComponent(0.1)
        container.layer.cornerRadius = 10
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12)
        label.textColor = theme.primaryColor
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        }
        
        // 添加点击动画
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tagTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        
        return container
    }
    
    // MARK: - Actions
    @objc private func deleteButtonTapped() {
        onDelete?()
    }
    
    @objc private func tagTapped(_ gesture: UITapGestureRecognizer) {
        guard let tagView = gesture.view else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            tagView.transform = CGAffineTransform(translationX: 0, y: -4)
        }) { _ in
            UIView.animate(withDuration: 0.25) {
                tagView.transform = .identity
            }
        }
    }
} 