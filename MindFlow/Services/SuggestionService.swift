import Foundation
import Defaults

// MARK: - 数据模型
struct SuggestionResponse: Codable {
    let success: Bool
    let message: String
    let data: SuggestionData
}

struct SuggestionData: Codable {
    let agentId: String
    let aiResponse: String
    let toolResults: ToolResults
    let invocationId: String
    
    enum CodingKeys: String, CodingKey {
        case agentId = "agent_id"
        case aiResponse = "ai_response"
        case toolResults = "tool_results"
        case invocationId = "invocation_id"
    }
}

struct ToolResults: Codable {
    let suggestion: SuggestionInfo
}

struct SuggestionInfo: Codable {
    let query: String
    let agentId: String?
    let userId: String?
    let chatHistory: [String]
    
    enum CodingKeys: String, CodingKey {
        case query
        case agentId = "agent_id"
        case userId = "user_id"
        case chatHistory = "chat_history"
    }
}

extension Defaults.Keys {
    // 匿名用户ID
    static let suggestions = Key<[String]?>("cached_suggestions_", default: nil)
    
    // 认证相关键
    static let cacheExpiration = Key<Date?>("cacheExpiration", default: nil)
    

}

// MARK: - 服务类
class SuggestionService {
    
    let cacheValidDuration: TimeInterval = 60 * 60 * 24 * 14  // 缓存有效期24 * 14小时
    
    func generateSuggestions(query: String, completion: @escaping (Result<[String], Error>) -> Void) {

        let url = AppConfig.shared.apiURL(AppConfig.APIPath.AISearch.suggest)
        let parameters: [String: Any] = ["query": query]
        
        NetworkManager.shared.post(url, parameters: parameters) { [weak self] (result: Result<SuggestionResponse, Error>) in
            switch result {
            case .success(let response):
                do {
                    // 解析 AI 响应中的建议数组
                    if let aiResponseData = response.data.aiResponse.data(using: .utf8),
                       let suggestions = try? JSONDecoder().decode([String: [String]].self, from: aiResponseData) {
                        let suggestionArray = suggestions["suggestions"] ?? []
                        
                        // 缓存建议数据
                        self?.cacheSuggestions(suggestionArray)
                        
                        completion(.success(suggestionArray))
                    } else {
                        completion(.success([]))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 获取缓存的建议
    func getCachedSuggestions() -> [String]? {
        // 检查缓存是否过期
        if let expirationDate = DefaultsManager.shared.get(for: .cacheExpiration) {
            if Date() < expirationDate {
                // 缓存未过期，返回缓存的数据
                return DefaultsManager.shared.get(for: .suggestions)
            } else {
                // 缓存已过期，清除缓存
                DefaultsManager.shared.remove(for: .suggestions)
                DefaultsManager.shared.remove(for: .cacheExpiration)
            }
        }
        
        return nil
    }
    
    // 缓存建议数据
    private func cacheSuggestions(_ suggestions: [String]) {
        // 存储建议数据
        DefaultsManager.shared.set(suggestions, for: .suggestions)
        
        // 设置过期时间
        let expirationDate = Date().addingTimeInterval(cacheValidDuration)
        DefaultsManager.shared.set(expirationDate, for: .cacheExpiration)
    }
} 
