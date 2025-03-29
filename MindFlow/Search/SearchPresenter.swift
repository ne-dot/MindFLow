//
//  SearchPresenter.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import Foundation

// View协议定义Presenter可以调用的方法
protocol SearchViewProtocol: AnyObject {
    func showThinkingView()
    func showResultsView()
    func updateRecentSearches(with suggestions: [String])
    func updateSearchResults(with results: [SearchResultItem])
    func showError(message: String)
}

class SearchPresenter {
    // 弱引用View，避免循环引用
    weak var view: SearchViewProtocol?
    
    // 依赖注入服务
    private let searchService: SearchService
    
    // 数据模型
    private var suggestions: [String] = []
    
    init(searchService: SearchService = SearchService()) {
        self.searchService = searchService
    }
    
    // 设置搜索建议
    func setSuggestions(_ suggestions: [String]) {
        self.suggestions = suggestions
        view?.updateRecentSearches(with: suggestions)
    }
    
    // 获取搜索建议
    func getSuggestions() -> [String] {
        return suggestions
    }
    
    // 执行搜索
    func performSearch(query: String) {
        guard !query.isEmpty else { return }
        
        // 通知View显示思考状态
        view?.showThinkingView()
        
        // 调用搜索服务
        searchService.search(query: query) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.success {
                        // 处理成功的搜索结果
                        let searchResults = self.searchService.processSearchResults(data: response.data)
                        self.view?.updateSearchResults(with: searchResults)
                        self.view?.showResultsView()
                    } else {
                        // 处理API返回的错误
                        self.view?.showError(message: response.message)
                    }
                    
                case .failure(let error):
                    // 处理网络错误
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
}
