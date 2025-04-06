import UIKit
import SnapKit

protocol SuggestionsStackViewDelegate: AnyObject {
    func suggestionsStackView(_ stackView: SuggestionsStackView, didSelectSuggestion suggestion: String)
}

class SuggestionsStackView: UIView {
    // MARK: - Properties
    weak var delegate: SuggestionsStackViewDelegate?
    private let suggestionService = SuggestionService()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        loadCachedSuggestions() // 初始化时加载缓存的建议
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = theme.backgroundColor
    
        addSubview(stackView)
        
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
    }
    
    // MARK: - Public Methods
    func updateSuggestions(_ suggestions: [String]) {
        // 清除现有建议
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 添加新的建议
        for suggestion in suggestions {
            let suggestionView = createSuggestionView(with: suggestion)
            stackView.addArrangedSubview(suggestionView)
        }
    }
    
    // 添加加载缓存建议的方法
    func loadCachedSuggestions() {
        // 先尝试从缓存加载
        if let suggestions = suggestionService.getCachedSuggestions() {
            updateSuggestions(suggestions)
        }
        
        // 同时请求新数据
        suggestionService.fetchSuggestions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let suggestions):
                    self?.updateSuggestions(suggestions)
                case .failure(let error):
                    print("获取建议失败：\(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func createSuggestionView(with text: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = theme.secondaryBackgroundColor
        containerView.layer.cornerRadius = 8
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = theme.secondaryTextColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(suggestionTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
        
        // 存储建议文本
        containerView.accessibilityLabel = text
        
        return containerView
    }
    
    @objc private func suggestionTapped(_ gesture: UITapGestureRecognizer) {
        guard let containerView = gesture.view,
              let suggestionText = containerView.accessibilityLabel else { return }
        delegate?.suggestionsStackView(self, didSelectSuggestion: suggestionText)
    }
} 
