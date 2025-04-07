import UIKit
import SnapKit

class NavigationBar: UIView {
    
    // MARK: - Properties
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    // 控制元素显示的属性
    var showsLeftButton: Bool = true {
        didSet {
            leftButton.isHidden = !showsLeftButton
        }
    }
    
    var showsRightButton: Bool = true {
        didSet {
            rightButton.isHidden = !showsRightButton
        }
    }
    
    var showsSeparator: Bool = true {
        didSet {
            separatorView.isHidden = !showsSeparator
        }
    }
    
    // 导航栏内容高度（不包含状态栏）
    private let navigationBarHeight: CGFloat = 44
    
    private var statusBarHeight: CGFloat {
        // 从 window 获取安全区域高度
        if let window = UIApplication.shared.windows.first {
            return window.safeAreaInsets.top
        }
        // 如果获取失败，使用状态栏高度
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    // 总高度（包含状态栏）
    var totalHeight: CGFloat {
        return navigationBarHeight + statusBarHeight
    }
    
    // MARK: - UI Components
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = theme.textColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = theme.textColor
        button.isHidden = true
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = theme.textColor
        button.isHidden = true
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.borderColor
        return view
    }()
    
    // MARK: - Callbacks
    var onLeftButtonTapped: (() -> Void)?
    var onRightButtonTapped: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        
        // 添加内容视图
        addSubview(contentView)
        
        // 添加导航栏元素到内容视图
        contentView.addSubview(titleLabel)
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        addSubview(separatorView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // 内容视图约束（位于状态栏下方）
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(navigationBarHeight)
        }
        
        // 标题约束
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualTo(leftButton.snp.right).offset(10)
            make.right.lessThanOrEqualTo(rightButton.snp.left).offset(-10)
        }
        
        // 左按钮约束
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        
        // 右按钮约束
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        
        // 分割线约束
        separatorView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }


    // MARK: - Public Methods
    func setLeftButton(image: UIImage?, title: String? = nil) {
        leftButton.isHidden = false
        if let image = image {
            leftButton.setImage(image, for: .normal)
        }
        if let title = title {
            leftButton.setTitle(title, for: .normal)
        }
    }
    
    func setRightButton(image: UIImage?, title: String? = nil) {
        rightButton.isHidden = false
        if let image = image {
            rightButton.setImage(image, for: .normal)
        }
        if let title = title {
            rightButton.setTitle(title, for: .normal)
        }
    }
    
    // MARK: - Actions
    @objc private func leftButtonTapped() {
        onLeftButtonTapped?()
    }
    
    @objc private func rightButtonTapped() {
        onRightButtonTapped?()
    }
    
    func hideLeftButton() {
        showsLeftButton = false
    }
    
    func hideSeparator() {
        showsSeparator = false
    }
    
    func showSeparator() {
        showsSeparator = true
    }
} 
