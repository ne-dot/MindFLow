import Foundation

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
                    NetworkManager.shared.setAnonymousId(response.data.anonymousId)
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
}