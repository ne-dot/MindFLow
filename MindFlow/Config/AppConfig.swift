import Foundation

enum Environment {
    case development
    case staging
    case production
    
    // 当前环境
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

struct AppConfig {
    // 单例模式
    static let shared = AppConfig()
    
    private init() {}
    
    // 基础URL
    var baseURL: String {
        switch Environment.current {
        case .development:
            return "http://localhost:8000"
        case .staging:
            return "https://staging-api.mindflow.com"
        case .production:
            return "https://api.mindflow.com"
        }
    }
    
    // API路径
    struct APIPath {
        // 用户相关
        struct User {
            static let anonymousLogin = "/api/users/anonymous-login"
            static let login = "/api/users/login"
            static let register = "/api/users/register"
            static let profile = "/api/users/me"
        }
        
        // 内容相关
        struct Content {
            static let list = "/api/contents"
            static let detail = "/api/contents/"  // 后面需要拼接ID
            static let favorite = "/api/contents/favorite"
        }
        
        // AI search
        struct AISearch {
            static let search = "/api/search"
            static let suggest = "/api/suggestions/generate"
            static let suggestions = "/api/suggestions"
        }
    }
    
    // 完整API URL
    func apiURL(_ path: String) -> String {
        return baseURL + path
    }
}
