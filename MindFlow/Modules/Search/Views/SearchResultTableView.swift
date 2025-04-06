//
//  SearchResultTableView.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit

protocol SearchResultTableViewDelegate: AnyObject {
    // ... 现有的代理方法 ...
    func searchResultView(_ view: SearchResultTableView, didSelectSuggestion suggestion: String)
}

// 在SearchResultTableView类中添加对AI回复卡片的支持
class SearchResultTableView: UIView {
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        // 注册单元格
        tableView.register(ResultCardView.self, forCellReuseIdentifier: "ResultCardCell")
        tableView.register(AIResponseCardView.self, forCellReuseIdentifier: "AIResponseCell")
        
        // 设置代理和数据源
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    // 添加建议相关的视图组件
    private lazy var suggestionsFooterView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.backgroundColor
        return view
    }()
    
    private lazy var suggestionsTitle: UILabel = {
        let label = UILabel()
        label.text = "相关搜索"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = theme.secondaryTextColor
        return label
    }()
    
    private lazy var suggestionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Properties
    private var searchResults: [SearchResultItem] = []
    
    // 添加流式数据相关属性
    private var currentContent: String = ""
    private var aiResponseItem: SearchResultItem?
    
    // 添加代理属性
    weak var delegate: SearchResultTableViewDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = theme.backgroundColor
        
        addSubview(tableView)
        
        // 设置约束
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 设置建议 footer view
        setupSuggestionsFooterView()
    }
    
    private func setupSuggestionsFooterView() {
        suggestionsFooterView.addSubview(suggestionsTitle)
        suggestionsFooterView.addSubview(suggestionsStackView)
        
        suggestionsTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        suggestionsStackView.snp.makeConstraints { make in
            make.top.equalTo(suggestionsTitle.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    // 移除loadSampleResults方法
    
    // MARK: - Public Methods
    func loadResults(for query: String) {
        // 这个方法现在可以留空，或者完全移除
        // 因为我们将使用updateResults方法来更新搜索结果
        tableView.reloadData()
    }
    
    // 添加更新结果的方法
    func updateResults(_ results: [SearchResultItem]) {
        // 先清空当前内容
        currentContent = ""
        
        // 检查是否已经有AI响应类型的cell
        let hasAIResponse = results.contains { $0.id == "ai-response-stream" }
        
        if !hasAIResponse {
            // 如果没有AI响应类型的cell，创建一个空的并放在第一位
            let aiResponseItem = SearchResultItem(
                id: "ai-response-stream",
                title: "MindFlow AI",
                description: "",
                contextLink: "",
                source: "",
                imageUrl: nil,
                isFavorited: false,
                isBookmarked: false,
                type: .aiResponse
            )
            
            // 创建新的结果数组，将AI响应放在第一位
            var newResults = results
            newResults.insert(aiResponseItem, at: 0)
            self.searchResults = newResults
            self.aiResponseItem = aiResponseItem
        } else {
            // 如果已经有AI响应类型的cell，直接使用传入的结果
            self.searchResults = results
            self.aiResponseItem = results.first { $0.id == "ai-response-stream" }
        }
        
        tableView.reloadData()
    }
    
    // 添加内容块
    func appendContent(_ content: String) {
        currentContent += content
        
        // 检查是否存在AI响应类型的cell
        if let index = searchResults.firstIndex(where: { $0.id == "ai-response-stream" }) {
            // 已存在AI响应，更新它
            let currentItem = searchResults[index]
            
            let updatedItem = SearchResultItem(
                id: "ai-response-stream",
                title: currentItem.title,
                description: currentContent,
                contextLink: currentItem.contextLink,
                source: currentItem.source,
                imageUrl: currentItem.imageUrl,
                isFavorited: currentItem.isFavorited,
                isBookmarked: currentItem.isBookmarked,
                type: .aiResponse
            )
            
            // 替换现有项
            searchResults[index] = updatedItem
            aiResponseItem = updatedItem
            
            // 直接更新cell内容，而不是重新加载整行
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? AIResponseCardView {
                cell.renderMarkdown(currentContent)
                
                // 通知tableView更新布局，但不重新加载单元格
                UIView.performWithoutAnimation {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
        }
        // 移除了else分支，因为updateResults已经确保了AI响应cell的存在
    }
    
    // 设置查询标题
    func setQueryTitle(_ query: String) {
        // 由于title是let常量，我们不能直接修改它
        // 创建一个新的AI响应项来替换现有的
        if let index = searchResults.firstIndex(where: { $0.id == "ai-response-stream" }) {
            let updatedItem = SearchResultItem(
                id: "ai-response-stream",
                title: "搜索结果: \(query)",
                description: currentContent,
                contextLink: "",
                source: "",
                imageUrl: nil,
                isFavorited: false,
                isBookmarked: false,
                type: .aiResponse
            )
            
            // 替换现有项
            searchResults[index] = updatedItem
            aiResponseItem = updatedItem
            
            // 更新表格中的第一行
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    // 显示错误信息
    func showError(message: String) {
        let errorText = "\n\n[错误: \(message)]"
        appendContent(errorText)
    }
    
    // 更新来源
    func updateSources(sources: [String]) {
        // 在这个实现中，我们可以将来源添加为普通的搜索结果
        // 或者在AI响应中添加来源信息
        // 这里简单地将它们添加到AI响应的描述中
        
        if !sources.isEmpty {
            var sourcesText = "\n\n来源:\n"
            for source in sources {
                sourcesText += "- \(source)\n"
            }
            
            appendContent(sourcesText)
        }
    }
    
    // 添加更新建议的方法
    func updateSuggestions(_ suggestions: [String]) {
        // 清除现有建议
        suggestionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 如果没有建议，移除 footer view
        if suggestions.isEmpty {
            tableView.tableFooterView = nil
            return
        }
        
        // 为每个建议创建按钮
        for suggestion in suggestions {
            let button = createSuggestionButton(with: suggestion)
            suggestionsStackView.addArrangedSubview(button)
        }
        
        // 设置并更新 footer view
        tableView.tableFooterView = suggestionsFooterView
        
        // 重新计算 footer view 的高度
        let width = tableView.bounds.width
        let fittingSize = suggestionsFooterView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        suggestionsFooterView.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: fittingSize.height
        )
        
        tableView.tableFooterView = suggestionsFooterView
    }
    
    private func createSuggestionButton(with text: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = theme.secondaryBackgroundColor
        containerView.layer.cornerRadius = 8
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = theme.textColor
        label.numberOfLines = 0 // 支持多行
        label.lineBreakMode = .byWordWrapping
        
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(suggestionTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
        
        // 存储建议文本，用于点击时识别
        containerView.accessibilityLabel = text
        
        return containerView
    }
    
    @objc private func suggestionTapped(_ gesture: UITapGestureRecognizer) {
        guard let containerView = gesture.view,
              let suggestionText = containerView.accessibilityLabel else { return }
        delegate?.searchResultView(self, didSelectSuggestion: suggestionText)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchResultTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = searchResults[indexPath.row]
        
        switch result.type {
        case .aiResponse:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AIResponseCell", for: indexPath) as? AIResponseCardView else {
                return UITableViewCell()
            }
            
            cell.configure(with: result.description)
            
            // 设置回调
            cell.onCopy = {
                print("复制AI回复")
                UIPasteboard.general.string = result.description
            }
            
            cell.onShare = {
                print("分享AI回复")
                // 这里可以添加分享功能
                if let topVC = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() {
                    let activityVC = UIActivityViewController(activityItems: [result.description], applicationActivities: nil)
                    topVC.present(activityVC, animated: true)
                }
            }
            
            cell.onLike = { isLiked in
                print("点赞AI回复: \(isLiked)")
                // 可以添加点赞后的处理逻辑
            }
            
            cell.onDislike = { isDisliked in
                print("踩AI回复: \(isDisliked)")
                // 可以添加踩后的处理逻辑
            }
            
            return cell
            
        case .normalResult:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCardCell", for: indexPath) as? ResultCardView else {
                return UITableViewCell()
            }
            
            cell.configure(
                with: result.imageUrl,
                title: result.title,
                description: result.description,
                source: result.source,
                isFavorited: result.isFavorited,
                isBookmarked: result.isBookmarked
            )
            
            // 设置回调
            cell.onFavorite = { [weak self] isFavorited in
                self?.searchResults[indexPath.row].isFavorited = isFavorited
            }
            
            cell.onBookmark = { [weak self] isBookmarked in
                self?.searchResults[indexPath.row].isBookmarked = isBookmarked
            }
            
            cell.onClose = { [weak self] in
                guard let self = self else { return }
                
                // 动画移除单元格
                self.searchResults.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .right)
            }
            
            return cell
        }
    }
    
    // 添加点击事件处理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        
        // 只处理普通结果的点击事件，AI回复不需要跳转
        if case .normalResult = result.type, !result.contextLink.isEmpty {
            // 跳转到WebView
            if let url = URL(string: result.contextLink) {
                let webViewController = WebViewController(url: url)
                if let topVC = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() {
                    topVC.navigationController?.pushViewController(webViewController, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let result = searchResults[indexPath.row]
        
        switch result.type {
        case .aiResponse:
            // AI回复卡片高度自适应
            return UITableView.automaticDimension
        case .normalResult:
            // 普通结果卡片固定高度
            return result.imageUrl != nil ? 340 : 180
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let result = searchResults[indexPath.row]
        
        switch result.type {
        case .aiResponse:
            return 300 // 估计高度
        case .normalResult:
            return result.imageUrl != nil ? 340 : 180
        }
    }
}
