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
    private let searchIcon = UIImageView()
    private let searchTextField = UITextField()
    private let clearButton = UIButton(type: .system)
    
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
        searchHeader.addSubview(searchInputContainer)
        searchInputContainer.addSubview(searchIcon)
        searchInputContainer.addSubview(searchTextField)
        searchInputContainer.addSubview(clearButton)
        
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
            make.height.equalTo(60)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        searchInputContainer.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(searchIcon.snp.right).offset(8)
            make.right.equalTo(clearButton.snp.left).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        // 最近搜索视图约束
        recentSearchesView.snp.makeConstraints { make in
            make.top.equalTo(searchHeader.snp.bottom).offset(24)
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
            make.top.equalTo(searchHeader.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 搜索结果视图约束
        searchResultView.snp.makeConstraints { make in
            make.top.equalTo(searchHeader.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupSearchHeader() {
        // 返回按钮
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = theme.text
        
        // 搜索输入容器
        searchInputContainer.backgroundColor = theme.textBackground
        searchInputContainer.layer.cornerRadius = 25
        
        // 搜索图标
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = theme.iconColor
        
        // 搜索文本框
        searchTextField.placeholder = "Search anything..."
        searchTextField.textColor = theme.text
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search anything...",
            attributes: [NSAttributedString.Key.foregroundColor: theme.searchPlaceholder]
        )
        searchTextField.borderStyle = .none
        searchTextField.returnKeyType = .search
        searchTextField.clearButtonMode = .never
        searchTextField.autocorrectionType = .no
        
        // 清除按钮
        clearButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        clearButton.tintColor = theme.iconColor
        clearButton.isHidden = true
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
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        searchTextField.delegate = self
    }
    
    @objc private func backButtonTapped() {
        onClose?()
    }
    
    @objc private func clearButtonTapped() {
        searchTextField.text = ""
        clearButton.isHidden = true
    }
    
    @objc private func searchTextChanged() {
        clearButton.isHidden = searchTextField.text?.isEmpty ?? true
    }
    
    @objc private func recentItemTapped(_ gesture: UITapGestureRecognizer) {
        if let view = gesture.view, view.tag < suggestions.count {
            let suggestion = suggestions[view.tag]
            searchTextField.text = suggestion
            clearButton.isHidden = false
            handleSearch()
        }
    }
    
    // 修改handleSearch方法中的动画部分
    // 修改handleSearch方法，使用SearchService
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
    private func updateUI() {
        recentSearchesView.isHidden = isThinking || showResults
        thinkingView.isHidden = !isThinking
        searchResultView.isHidden = !showResults
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSearch()
        textField.resignFirstResponder()
        return true
    }
}
