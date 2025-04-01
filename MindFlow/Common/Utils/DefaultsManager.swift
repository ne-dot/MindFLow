import Foundation
import Defaults

// 定义存储的键
extension Defaults.Keys {
    // 匿名用户ID
    static let anonymousId = Key<String?>("anonymousId", default: nil)
    
    // 认证相关键
    static let accessToken = Key<String?>("accessToken", default: nil)
    static let refreshToken = Key<String?>("refreshToken", default: nil)
    static let tokenExpiresIn = Key<Int>("tokenExpiresIn", default: 0)
    static let isLoggedIn = Key<Bool>("isLoggedIn", default: false)
    
    // 可以在这里添加更多键
    // static let someOtherKey = Key<ValueType>("keyName", default: defaultValue)
}

class DefaultsManager {
    static let shared = DefaultsManager()
    
    private init() {}
    
    // MARK: - 通用方法
    
    // 设置值
    func set<T>(_ value: T, for key: Defaults.Keys.Key<T>) {
        Defaults[key] = value
    }
    
    // 获取值
    func get<T>(for key: Defaults.Keys.Key<T>) -> T {
        return Defaults[key]
    }
    
    // 移除值
    func remove<T>(for key: Defaults.Keys.Key<T>) where T: ExpressibleByNilLiteral {
        Defaults[key] = nil
    }
    
    // MARK: - 特定方法
    
    // 设置匿名ID
    func setAnonymousId(_ id: String) {
        set(id, for: .anonymousId)
    }
    
    // 获取匿名ID
    func getAnonymousId() -> String? {
        return get(for: .anonymousId)
    }
    
    // 清除匿名ID
    func clearAnonymousId() {
        remove(for: .anonymousId)
    }
    
    // MARK: - 认证相关方法
    
    // 设置访问令牌
    func setAccessToken(_ token: String?) {
        set(token, for: .accessToken)
    }
    
    // 获取访问令牌
    func getAccessToken() -> String? {
        return get(for: .accessToken)
    }
    
    // 设置刷新令牌
    func setRefreshToken(_ token: String?) {
        set(token, for: .refreshToken)
    }
    
    // 获取刷新令牌
    func getRefreshToken() -> String? {
        return get(for: .refreshToken)
    }
    
    // 设置令牌过期时间
    func setTokenExpiresIn(_ expiresIn: Int) {
        set(expiresIn, for: .tokenExpiresIn)
    }
    
    // 获取令牌过期时间
    func getTokenExpiresIn() -> Int {
        return get(for: .tokenExpiresIn)
    }
    
    // 设置登录状态
    func setIsLoggedIn(_ isLoggedIn: Bool) {
        set(isLoggedIn, for: .isLoggedIn)
    }
    
    // 获取登录状态
    func getIsLoggedIn() -> Bool {
        return get(for: .isLoggedIn)
    }
    
    // 清除认证数据
    func clearAuthData() {
        remove(for: .accessToken)
        remove(for: .refreshToken)
        set(0, for: .tokenExpiresIn)
        set(false, for: .isLoggedIn)
    }
}