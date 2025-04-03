import UIKit
import SnapKit

protocol QuickActionsViewDelegate: AnyObject {
    func quickActionTapped(at index: Int)
}

class QuickActionsView: UIView {
    // MARK: - Properties
    weak var delegate: QuickActionsViewDelegate?
    
    private let actionItems: [(icon: String, title: String)]
    
    // MARK: - UI Components
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    // MARK: - Initialization
    init(actionItems: [(String, String)]) {
        self.actionItems = actionItems
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.actionItems = []
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        for (index, item) in actionItems.enumerated() {
            let button = createActionButton(icon: item.icon, title: item.title, tag: index)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createActionButton(icon: String, title: String, tag: Int) -> UIView {
        let container = UIView()
        container.backgroundColor = theme.secondaryBackgroundColor
        container.layer.cornerRadius = 12
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.tintColor = theme.primaryColor
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = theme.textColor
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        container.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionButtonTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.tag = tag
        
        return container
    }
    
    // MARK: - Actions
    @objc private func actionButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        delegate?.quickActionTapped(at: view.tag)
    }
}
