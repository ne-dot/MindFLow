import UIKit
import SnapKit

protocol SettingsSectionViewDelegate: AnyObject {
    func settingItemTapped(title: String)
}

class SettingsSectionView: UIView {
    // MARK: - Properties
    weak var delegate: SettingsSectionViewDelegate?
    
    // MARK: - UI Components
    private let icon: String
    private let title: String
    private let items: [(title: String, value: String?, isToggle: Bool?)]
    
    // MARK: - Initialization
    init(icon: String, title: String, items: [(String, String?, Bool?)]) {
        self.icon = icon
        self.title = title
        self.items = items
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.icon = ""
        self.title = ""
        self.items = []
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 0.5
        layer.borderColor = theme.borderColor.cgColor
        
        let headerView = createHeaderView()
        let itemsStackView = createItemsStackView()
        
        addSubview(headerView)
        addSubview(itemsStackView)
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        itemsStackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView()
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.tintColor = theme.primaryColor
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = theme.textColor
        
        headerView.addSubview(iconImageView)
        headerView.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }
    
    private func createItemsStackView() -> UIStackView {
        let itemsStackView = UIStackView()
        itemsStackView.axis = .vertical
        itemsStackView.spacing = 4
        
        for (index, item) in items.enumerated() {
            let itemView = createSettingItem(title: item.title, value: item.value, isToggle: item.isToggle ?? false)
            itemsStackView.addArrangedSubview(itemView)
            
            // 添加分隔线，除了最后一项
            if index < items.count - 1 {
                let separator = UIView()
                separator.backgroundColor = theme.borderColor
                separator.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                }
                itemsStackView.addArrangedSubview(separator)
            }
        }
        
        return itemsStackView
    }
    
    private func createSettingItem(title: String, value: String?, isToggle: Bool) -> UIView {
        let itemView = UIView()
        itemView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = theme.textColor
        
        itemView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        if isToggle {
            let toggle = UISwitch()
            toggle.onTintColor = theme.primaryColor
            itemView.addSubview(toggle)
            
            toggle.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        } else {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.alignment = .center
            
            if let value = value {
                let valueLabel = UILabel()
                valueLabel.text = value
                valueLabel.font = UIFont.systemFont(ofSize: 14)
                valueLabel.textColor = value == "高级版" ? theme.primaryColor : .systemGray2
                stackView.addArrangedSubview(valueLabel)
            }
            
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            chevronImageView.tintColor = .systemGray3
            chevronImageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(chevronImageView)
            
            itemView.addSubview(stackView)
            
            stackView.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            chevronImageView.snp.makeConstraints { make in
                make.width.height.equalTo(12)
            }
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(settingItemTapped(_:)))
        itemView.addGestureRecognizer(tapGesture)
        itemView.accessibilityIdentifier = title
        
        return itemView
    }
    
    // MARK: - Actions
    @objc private func settingItemTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view, let identifier = view.accessibilityIdentifier else { return }
        delegate?.settingItemTapped(title: identifier)
    }
}
