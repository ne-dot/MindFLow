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

// 添加流式事件类型
enum StreamEventType: String, Codable {
    case start = "start"
    case chunk = "chunk"
    case end = "end"
    case error = "error"
    case googleResults = "google_results" // 添加Google结果事件类型
}

// 修改流式事件数据模型，添加Google结果字段
struct StreamEventData: Codable {
    let content: String?
    let query: String?
    let error: String?
    let results: [GoogleImageResult]? // 添加Google图片结果数组
}

// 添加Google图片结果模型
struct GoogleImageResult: Codable {
    let title: String
    let link: String
    let thumbnailLink: String?
    let contextLink: String
    let snippet: String
    let source: String
}

// 添加流式事件模型
struct StreamEvent: Codable {
    let event: StreamEventType
    let data: StreamEventData
}

// 添加流式搜索回调类型
typealias StreamHandler = (StreamEvent) -> Void
typealias StreamErrorHandler = (Error) -> Void
typealias StreamCompletionHandler = () -> Void

class SearchService {
    // 移除单例模式
    
    // 从配置获取搜索API地址
    private var searchAPIURL: String {
        return AppConfig.shared.baseURL + "/api/search"
    }
    
    // 从配置获取流式搜索API地址
    private var streamSearchAPIURL: String {
        return AppConfig.shared.baseURL + "/api/search"
    }
    
    // 初始化方法
    init() {}
    
    // 添加流式搜索方法
    func streamSearch(
        query: String,
        onEvent: @escaping StreamHandler,
        onError: @escaping StreamErrorHandler,
        onCompletion: @escaping StreamCompletionHandler
    ) -> DataRequest {
        let parameters: Parameters = [
            "query": query
        ]
        
        print("开始流式搜索，查询: \(query)")
        
        // 使用 NetworkManager 处理流式请求
        var buffer = ""
        
        return NetworkManager.shared.streamRequest(
            streamSearchAPIURL,
            method: .post,
            parameters: parameters,
            onDataStream: { data, response in
                // 将新接收的数据添加到缓冲区
                if let string = String(data: data, encoding: .utf8) {
                    buffer += string
                    
                    // 处理接收到的数据块
                    // 查找所有完整的事件（以data:开头的行）
                    let pattern = "data: .*?(?=\\ndata:|$)"
                    if let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) {
                        let nsString = buffer as NSString
                        let matches = regex.matches(in: buffer, options: [], range: NSRange(location: 0, length: nsString.length))
                        
                        
                        // 处理找到的每个事件
                        for match in matches {
                            let eventString = nsString.substring(with: match.range)
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            
                            if eventString.hasPrefix("data: ") {
                                let jsonString = eventString.dropFirst(6) // 移除 "data: " 前缀
                                print("解析JSON: \(jsonString)")
                                self.processEventString(String(jsonString), onEvent: onEvent)
                            }
                        }
                        
                        // 如果找到了匹配项，清除已处理的部分
                        if let lastMatch = matches.last {
                            let endIndex = lastMatch.range.location + lastMatch.range.length
                            let oldBuffer = buffer
                            buffer = nsString.substring(from: endIndex)
                        }
                    }
                }
            },
            onError: { error in
                print("流式搜索错误: \(error)")
                onError(error)
            },
            onCompletion: {
                print("流式搜索完成")
                onCompletion()
            }
        )
    }
    
    // 处理事件字符串
    private func processEventString(_ eventString: String, onEvent: @escaping StreamHandler) {
        do {
            if let data = eventString.data(using: .utf8) {
                let event = try JSONDecoder().decode(StreamEvent.self, from: data)
                print("成功解析事件: \(event.event.rawValue)")
                
                // 如果是Google结果事件，处理图片结果
                if event.event == .googleResults && event.data.results != nil {
                    print("接收到Google图片搜索结果: \(event.data.results?.count ?? 0)个")
                    // 这里可以添加额外的处理逻辑
                }
                
                onEvent(event)
            }
        } catch {
            print("解析事件错误: \(error), 原始字符串: \(eventString)")
        }
    }
    
    // 添加处理Google图片结果的方法
    func processGoogleImageResults(results: [GoogleImageResult]) -> [SearchResultItem] {
        return results.enumerated().map { index, result in
            return SearchResultItem(
                id: "google-image-\(index)",
                title: result.title,
                description: result.snippet,
                contextLink: result.contextLink,
                source: result.source,
                imageUrl: result.thumbnailLink ?? result.link, // 优先使用缩略图
                isFavorited: false,
                isBookmarked: false,
                type: .normalResult
            )
        }
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
