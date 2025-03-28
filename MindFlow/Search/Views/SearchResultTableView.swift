//
//  SearchResultTableView.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit

// 搜索结果数据模型



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
    
    // MARK: - Properties
    private var searchResults: [SearchResultItem] = []
    
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
        backgroundColor = theme.background
        
        addSubview(tableView)
        
        // 设置约束
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        self.searchResults = results
        tableView.reloadData()
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
