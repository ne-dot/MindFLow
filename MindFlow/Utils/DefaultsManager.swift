import Foundation
import Defaults

// 定义存储的键
extension Defaults.Keys {
    // 匿名用户ID
    static let anonymousId = Key<String?>("anonymousId", default: nil)
    
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
}