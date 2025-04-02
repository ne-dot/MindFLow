//
//  SearchPresenter.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import Foundation
import Alamofire

// View协议定义Presenter可以调用的方法
// 在 SearchViewProtocol 中添加流式搜索相关的方法
protocol SearchViewProtocol: AnyObject {
    func showThinkingView()
    func showResultsView()
    func updateRecentSearches(with suggestions: [String])
    func updateSearchResults(with results: [SearchResultItem])
    func showError(message: String)
    
    // 新增流式搜索相关方法
    func clearSearchContent()
    func setSearchQueryTitle(_ query: String)
    func appendSearchContent(_ content: String)
    func updateSearchSources(sources: [String])
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
    
    // 添加流式搜索相关属性
    private var streamRequest: DataRequest?
    
    // 执行流式搜索
    func performStreamSearch(query: String) {
        guard !query.isEmpty else { return }
        
        // 取消之前的请求
        cancelStreamRequest()
        
        // 通知View显示思考状态
        view?.showThinkingView()
        view?.clearSearchContent()
        view?.setSearchQueryTitle(query)
        
        // 清除之前的搜索结果
        view?.updateSearchResults(with: [])
        
        // 调用搜索服务的流式搜索方法
        streamRequest = searchService.streamSearch(
            query: query,
            onEvent: { [weak self] event in
                self?.handleStreamEvent(event)
            },
            onError: { [weak self] error in
                DispatchQueue.main.async {
                    self?.view?.showError(message: error.localizedDescription)
                    self?.view?.showResultsView() // 即使出错也显示结果页面
                }
            },
            onCompletion: { [weak self] in
                DispatchQueue.main.async {
                    // 流式请求完成后的处理
                    self?.streamRequest = nil
                    
                    // 确保显示结果页面
                    self?.view?.showResultsView()
                    
                    // 更新来源
                    let sources = self?.extractSourcesFromContent() ?? []
                    self?.view?.updateSearchSources(sources: sources)
                }
            }
        )
    }
    
    // 取消流式请求
    func cancelStreamRequest() {
        streamRequest?.cancel()
        streamRequest = nil
    }
    
    // 处理流式事件
    private func handleStreamEvent(_ event: StreamEvent) {
        DispatchQueue.main.async { [weak self] in
            switch event.event {
            case .start:
                if let query = event.data.query {
                    self?.view?.showResultsView()
                    self?.view?.setSearchQueryTitle(query)
                }
                
            case .chunk:
                if let content = event.data.content {
                    self?.view?.appendSearchContent(content)
                }
                
            case .end:
                // 结束事件处理
                self?.view?.showResultsView()
                
            case .error:
                if let errorMessage = event.data.error {
                    self?.view?.showError(message: errorMessage)
                }
                
            case .googleResults:
                // 处理Google搜索结果
                if let results = event.data.results {
                    let searchResults = self?.processGoogleResults(results) ?? []
                    self?.view?.updateSearchResults(with: searchResults)
                }
            }
        }
    }
    
    // 处理Google搜索结果
    private func processGoogleResults(_ results: [GoogleImageResult]) -> [SearchResultItem] {
        return results.enumerated().map { index, result in
            return SearchResultItem(
                id: "google-image-\(index)",
                title: result.title,
                description: result.snippet,
                contextLink: result.contextLink,
                source: result.source,
                imageUrl: result.thumbnailLink ?? result.link,
                isFavorited: false,
                isBookmarked: false,
                type: .normalResult
            )
        }
    }
    
    // 从内容中提取来源
    private func extractSourcesFromContent() -> [String] {
        // 这里可以实现从内容中提取来源的逻辑
        // 简单示例
        return ["搜索结果", "相关网站"]
    }
}
