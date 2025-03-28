//
//  SearchService.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import Foundation
import Alamofire

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
}
