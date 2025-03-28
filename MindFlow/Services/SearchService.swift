//
//  SearchService.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import Foundation
import Alamofire


// 修改SearchResultItem结构体，添加类型字段
struct SearchResultItem {
    enum ResultType {
        case aiResponse
        case normalResult
    }
    
    let id: String
    let title: String
    let description: String
    let contextLink: String
    let source: String
    let imageUrl: String?
    var isFavorited: Bool
    var isBookmarked: Bool
    let type: ResultType // 新增类型字段
}

class SearchService {
    // 移除单例模式
    
    // 从配置获取搜索API地址
    private var searchAPIURL: String {
        return AppConfig.shared.baseURL + "/api/search"
    }
    
    // 初始化方法
    init() {}
    
    // 执行搜索请求
    func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        let parameters: Parameters = [
            "query": query
        ]
        
        NetworkManager.shared.post(searchAPIURL, parameters: parameters, completion: completion)
    }
    
    // 添加数据处理方法
    func processSearchResults(data: SearchData) -> [SearchResultItem] {
        // 创建AI响应结果
        let aiResult = SearchResultItem(
            id: "ai-response",
            title: "MindFlow AI",
            description: data.gptSummary,
            contextLink: "",
            source: "",
            imageUrl: nil,
            isFavorited: false,
            isBookmarked: false,
            type: .aiResponse
        )
        
        // 转换Google搜索结果
        let googleResults = data.googleResults.enumerated().map { index, result in
            return SearchResultItem(
                id: "google-\(index)",
                title: result.title,
                description: result.snippet,
                contextLink: result.contextLink,
                source: result.source,
                imageUrl: result.link,
                isFavorited: false,
                isBookmarked: false,
                type: .normalResult
            )
        }
        
        // 合并结果
        var allResults = [aiResult]
        allResults.append(contentsOf: googleResults)
        
        return allResults
    }
}

// MARK: - 搜索响应模型
struct SearchResponse: Codable {
    let success: Bool
    let message: String
    let data: SearchData
}

struct SearchData: Codable {
    let gptSummary: String
    let googleResults: [GoogleResult]
    
    enum CodingKeys: String, CodingKey {
        case gptSummary = "gpt_summary"
        case googleResults = "google_results"
    }
}

struct GoogleResult: Codable {
    let title: String
    let snippet: String
    let link: String
    let source: String
    let contextLink: String
}
