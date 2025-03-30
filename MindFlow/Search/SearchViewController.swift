//
//  SearchViewController.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit
import Lottie

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var onClose: (() -> Void)?
    private var isThinking = false
    private var showResults = false
    
    // 使用Presenter替代直接的Service调用
    private let presenter: SearchPresenter
    
    // MARK: - UI Components
    // 将所有UI组件改为惰性初始化
    private lazy var searchHeader: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.tintColor = theme.text
        return button
    }()
    
    private lazy var searchInputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = theme.background
        
        // 添加底部边框线
        let borderLine = UIView()
        borderLine.backgroundColor = theme.border
        view.addSubview(borderLine)
        borderLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        return view
    }()
    
    // 将UITextView替换为PlaceholderTextView
    private lazy var searchTextField: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.textColor = theme.text
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.returnKeyType = .search
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 24) // 右侧留出空间给清除按钮
        // 设置占位文本
        textView.placeholder = "Search anything..."
        textView.placeholderColor = theme.searchPlaceholder
        textView.delegate = self
        return textView
    }()
    
    // 添加一个属性来记录文本视图的初始高度
    private var initialTextViewHeight: CGFloat = 36
    
    private lazy var recentSearchesView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var recentTitle: UILabel = {
        let label = UILabel()
        label.text = "Recent Searches"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = theme.text
        return label
    }()
    
    private lazy var recentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 修改这里：将SearchResultView替换为SearchResultTableView
    private lazy var searchResultView: SearchResultTableView = {
        let tableView = SearchResultTableView()
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var thinkingView: ThinkingView = {
        let view = ThinkingView()
        view.isHidden = true
        return view
    }()
    
    // MARK: - Initialization
    init(presenter: SearchPresenter = SearchPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        self.presenter = SearchPresenter()
        super.init(coder: coder)
        self.presenter.view = self
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.background
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Public Methods
    func configure(with suggestions: [String]) {
        presenter.setSuggestions(suggestions)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addAllSubviews()
        setupAllConstraints()
        setupSearchHeader()
        setupSearchResultView()
        
        // 初始状态
        thinkingView.isHidden = true
        searchResultView.isHidden = true
    }
    
    private func addAllSubviews() {
        view.addSubview(searchHeader)
        searchHeader.addSubview(backButton)
        view.addSubview(searchInputContainer)
        searchInputContainer.addSubview(searchTextField)
        
        view.addSubview(recentSearchesView)
        recentSearchesView.addSubview(recentTitle)
        recentSearchesView.addSubview(recentStackView)
        
        view.addSubview(thinkingView)
        view.addSubview(searchResultView)
    }
    
    private func setupAllConstraints() {
        // 搜索头部约束
        searchHeader.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        searchInputContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            // 不再固定高度，而是根据内容自适应
            make.top.equalTo(searchHeader.snp.bottom).offset(0)
        }
    
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
            // 设置初始高度
            make.height.equalTo(initialTextViewHeight)
        }
        
        // 最近搜索视图约束
        recentSearchesView.snp.makeConstraints { make in
            make.top.equalTo(searchInputContainer.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        recentTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        recentStackView.snp.makeConstraints { make in
            make.top.equalTo(recentTitle.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        // 思考中视图约束
        thinkingView.snp.makeConstraints { make in
            make.top.equalTo(searchInputContainer.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 搜索结果视图约束
        searchResultView.snp.makeConstraints { make in
            make.top.equalTo(searchInputContainer.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupSearchHeader() {
        // 返回按钮
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = theme.text
        
        // 搜索输入容器
        searchInputContainer.backgroundColor = theme.background
        
        // 添加底部边框线
        let borderLine = UIView()
        borderLine.backgroundColor = theme.border
        searchInputContainer.addSubview(borderLine)
        borderLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        // 搜索文本框 - 移除不适用于UITextView的属性
        // 不需要设置placeholder，因为我们已经在初始化时设置了text和textColor
        // 不需要设置borderStyle，因为UITextView没有这个属性
        searchTextField.returnKeyType = .search
        searchTextField.autocorrectionType = .no
        
        // 清除按钮
//        clearButton.setImage(UIImage(systemName: "xmark"), for: .normal)
//        clearButton.tintColor = theme.iconColor
//        clearButton.isHidden = true
    }
    
    private func setupRecentSearches() {
        // 清除现有的搜索历史
        recentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 设置标题
        recentTitle.text = "Recent Searches"
        recentTitle.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        recentTitle.textColor = theme.text
        
        // 设置堆栈视图
        recentStackView.axis = .vertical
        recentStackView.spacing = 8
        recentStackView.distribution = .fillEqually
        
        // 添加搜索历史项
        let suggestions = presenter.getSuggestions()
        for suggestion in suggestions {
            let itemView = createRecentSearchItem(text: suggestion)
            recentStackView.addArrangedSubview(itemView)
        }
    }
    
    private func createRecentSearchItem(text: String) -> UIView {
        let itemView = UIView()
        
        let historyIcon = UIImageView()
        historyIcon.image = UIImage(systemName: "clock")
        historyIcon.tintColor = theme.subText
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.textColor = theme.text
        textLabel.font = UIFont.systemFont(ofSize: 14)
        
        itemView.addSubview(historyIcon)
        itemView.addSubview(textLabel)
        
        historyIcon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(historyIcon.snp.right).offset(12)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recentItemTapped(_:)))
        itemView.addGestureRecognizer(tapGesture)
        itemView.isUserInteractionEnabled = true
        
        // 使用presenter获取suggestions
        let suggestions = presenter.getSuggestions()
        itemView.tag = suggestions.firstIndex(of: text) ?? 0
        
        itemView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        return itemView
    }
    
    private func setupSearchResultView() {
        // 配置搜索结果视图
        searchResultView.isHidden = true
    }
    
    // MARK: - Actions
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        searchTextField.delegate = self
    }
    
    @objc private func clearButtonTapped() {
        // Just clear the text - the placeholder will show automatically
        searchTextField.text = ""
        
        // Reset text view height
        searchTextField.snp.updateConstraints { make in
            make.height.equalTo(initialTextViewHeight)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func backButtonTapped() {
        onClose?()
    }
    
    @objc private func recentItemTapped(_ gesture: UITapGestureRecognizer) {
        if let view = gesture.view {
            let suggestions = presenter.getSuggestions()
            if view.tag < suggestions.count {
                let suggestion = suggestions[view.tag]
                searchTextField.text = suggestion
                searchTextField.textColor = theme.text  // 确保文本颜色正确
                presenter.performStreamSearch(query: suggestion)
            }
        }
    }
    
    // 更新UI状态的方法
    private func updateUI() {
        recentSearchesView.isHidden = isThinking || showResults
        thinkingView.isHidden = !isThinking
        searchResultView.isHidden = !showResults
        
        // 更新搜索文本框状态
        if isThinking || showResults {
            // 设置为不可编辑的标题样式
            searchTextField.isEditable = false
            searchTextField.isScrollEnabled = false
            searchTextField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            
            // 移除占位符（如果有）
            if searchTextField.text.isEmpty {
                searchTextField.placeholder = ""
            }
            
            // 计算文本内容的实际高度
            let size = CGSize(width: searchTextField.frame.width, height: .infinity)
            let estimatedSize = searchTextField.sizeThatFits(size)
            
            // 设置最小高度，但允许根据内容增加高度
            let minHeight: CGFloat = 44
            let newHeight = max(estimatedSize.height, minHeight)
            
            // 更新高度约束
            searchTextField.snp.updateConstraints { make in
                make.height.equalTo(newHeight)
            }
            
            // 更新底部边框线的可见性
            updateBorderLineVisibility(hidden: false)
        } else {
            // 恢复为可编辑状态
            searchTextField.isEditable = true
            searchTextField.isScrollEnabled = true
            searchTextField.font = UIFont.systemFont(ofSize: 16)
            
            // 恢复占位符
            if searchTextField.text.isEmpty {
                searchTextField.placeholder = "Search anything..."
            }
            
            // 恢复自适应高度
            let size = CGSize(width: searchTextField.frame.width, height: .infinity)
            let estimatedSize = searchTextField.sizeThatFits(size)
            let newHeight = min(max(estimatedSize.height, initialTextViewHeight), 100)
            
            searchTextField.snp.updateConstraints { make in
                make.height.equalTo(newHeight)
            }
            
            // 更新底部边框线的可见性
            updateBorderLineVisibility(hidden: true)
        }
        
        // 平滑动画
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 添加一个方法来控制底部边框线的可见性
    private func updateBorderLineVisibility(hidden: Bool) {
        if let borderLine = searchInputContainer.subviews.first(where: { $0 != searchTextField }) {
            borderLine.isHidden = hidden
        }
    }
    
    // 显示错误提示
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "搜索失败",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - SearchViewProtocol 实现
extension SearchViewController: SearchViewProtocol {
    // 实现流式搜索相关方法
    func clearSearchContent() {
        searchResultView.clearContent()
    }
    
    func setSearchQueryTitle(_ query: String) {
        searchResultView.setQueryTitle(query)
    }
    
    func appendSearchContent(_ content: String) {
        searchResultView.appendContent(content)
    }
    
    func updateSearchSources(sources: [String]) {
        searchResultView.updateSources(sources: sources)
    }
    
    func showThinkingView() {
        isThinking = true
        showResults = false
        updateUI()
        thinkingView.startAnimating()
    }
    
    func showResultsView() {
        isThinking = false
        showResults = true
        updateUI()
        thinkingView.stopAnimating()
    }
    
    func updateRecentSearches(with suggestions: [String]) {
        // 清除现有的搜索历史
        recentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 添加搜索历史项
        for suggestion in suggestions {
            let itemView = createRecentSearchItem(text: suggestion)
            recentStackView.addArrangedSubview(itemView)
        }
    }
    
    func updateSearchResults(with results: [SearchResultItem]) {
        searchResultView.updateResults(results)
    }
    
    func showError(message: String) {
        showErrorAlert(message: message)
    }
    
    // 在搜索按钮点击或搜索栏提交时调用
    func performSearch(query: String) {
        // 保存搜索记录
//        saveSearchQuery(query)
        
        // 使用流式搜索替代普通搜索
        presenter.performStreamSearch(query: query)
    }
}

// MARK: - UITextViewDelegate
extension SearchViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Calculate text content height
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        // Set minimum and maximum height
        let minHeight: CGFloat = initialTextViewHeight
        let maxHeight: CGFloat = 100
        
        // Calculate new height (between min and max)
        let newHeight = min(max(estimatedSize.height, minHeight), maxHeight)
        
        // Update height constraint
        textView.snp.updateConstraints { make in
            make.height.equalTo(newHeight)
        }
        
        // Smooth animation
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Handle return key for search
        if text == "\n" {
            if !textView.text.isEmpty {
                presenter.performStreamSearch(query: textView.text)
            }
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
