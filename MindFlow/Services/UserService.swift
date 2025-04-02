import Foundation

// 添加登录响应模型
struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let data: LoginData
}

struct LoginData: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
}


class UserService {
    static let shared = UserService()
    
    private init() {}
    
    // 匿名登录
    func anonymousLogin(completion: @escaping (Result<AnonymousLoginData, Error>) -> Void) {
        let url = AppConfig.shared.apiURL(AppConfig.APIPath.User.anonymousLogin)
        
        NetworkManager.shared.post(url, parameters: nil) { (result: Result<AnonymousLoginResponse, Error>) in
            switch result {
            case .success(let response):
                if response.success {
                    // 保存匿名ID
                    DefaultsManager.shared.setAnonymousId(response.data.anonymousId)
                    completion(.success(response.data))
                } else {
                    let errorMessage = response.message
                    let error = NSError(domain: "UserService", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // 在UserService类中添加登录方法
    func login(usernameOrEmail: String, password: String, completion: @escaping (Result<LoginData, Error>) -> Void) {
        let url = AppConfig.shared.apiURL(AppConfig.APIPath.User.login)
        
        let parameters: [String: Any] = [
            "username_or_email": usernameOrEmail,
            "password": password
        ]
        
        NetworkManager.shared.post(url, parameters: parameters) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                if response.success {
                    // 使用DefaultsManager保存token信息
                    DefaultsManager.shared.setAccessToken(response.data.accessToken)
                    DefaultsManager.shared.setRefreshToken(response.data.refreshToken)
                    DefaultsManager.shared.setTokenExpiresIn(response.data.expiresIn)
                    DefaultsManager.shared.setIsLoggedIn(true)
                    
                    completion(.success(response.data))
                } else {
                    let error = NSError(domain: "UserService", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 退出登录
    func logout(completion: @escaping (Bool) -> Void) {
        // 清除用户数据
        DefaultsManager.shared.clearAuthData()
        
        // 退出成功
        completion(true)
    }
}
