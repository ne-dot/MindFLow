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
    private var suggestions: [String] = []
    private let searchService = SearchService() // Add this line
    
    
    // MARK: - UI Components
    private let searchHeader = UIView()
    private let backButton = UIButton(type: .system)
    private let searchInputContainer = UIView()
    
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
        return textView
    }()
    
    // 添加一个属性来记录文本视图的初始高度
    private var initialTextViewHeight: CGFloat = 36
    private let recentSearchesView = UIView()
    private let recentTitle = UILabel()
    private let recentStackView = UIStackView()
    
    // 修改这里：将SearchResultView替换为SearchResultTableView
    private let searchResultView = SearchResultTableView()
    
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
        self.suggestions = suggestions
        setupRecentSearches()
    }
    
    // MARK: - UI Setup
    // 修改属性声明部分
    private let thinkingView = ThinkingView()
    
    // 删除原来的setupThinkingView方法，并在setupUI方法中调用
    private func setupUI() {
        addAllSubviews()
        setupAllConstraints()
        setupSearchHeader()
        // 删除setupThinkingView()调用
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
        // 不再使用editingChanged事件，而是设置textView的delegate
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

    @objc private func searchTextChanged() {
        
    }
    
    @objc private func recentItemTapped(_ gesture: UITapGestureRecognizer) {
        if let view = gesture.view, view.tag < suggestions.count {
            let suggestion = suggestions[view.tag]
            searchTextField.text = suggestion
            searchTextField.textColor = theme.text  // 确保文本颜色正确
            handleSearch()
        }
    }
    
    // 修改handleSearch方法中的动画部分
    private func handleSearch() {
        guard let searchText = searchTextField.text, !searchText.isEmpty else { return }
        
        // 显示思考状态
        isThinking = true
        showResults = false
        updateUI()
        
        // 开始动画
        thinkingView.startAnimating()
        
        // 调用搜索服务
        searchService.search(query: searchText) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isThinking = false
                self.showResults = true
                self.updateUI()
                self.thinkingView.stopAnimating()
                
                switch result {
                case .success(let response):
                    if response.success {
                        // 处理成功的搜索结果
                        print("搜索成功: \(response.message)")
                        
                        // 使用SearchService处理数据
                        let searchResults = self.searchService.processSearchResults(data: response.data)
                        
                        // 更新搜索结果视图
                        self.searchResultView.updateResults(searchResults)
                    } else {
                        // 处理API返回的错误
                        self.showErrorAlert(message: response.message)
                    }
                    
                case .failure(let error):
                    // 处理网络错误
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    // 修改updateUI方法中的相关部分
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
                handleSearch()
            }
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}


// 移除原来的UITextFieldDelegate扩展
// extension SearchViewController: UITextFieldDelegate {
//     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//         handleSearch()
//         textField.resignFirstResponder()
//         return true
//     }
// }
