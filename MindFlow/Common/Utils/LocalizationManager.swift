import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()
    
    private init() {}
    
    // 获取当前语言
    var currentLanguage: String {
        get {
            // 从用户设置获取语言，如果没有则使用系统语言
//            if let savedLanguage = DefaultsManager.shared.get(for: .appLanguage) {
//                return savedLanguage
//            }
            
            // 获取系统语言
            let preferredLanguage = Locale.preferredLanguages.first ?? "en"
            
            // 如果是中文，返回zh-Hans，否则返回en
            if preferredLanguage.starts(with: "zh") {
                return "zh-Hans"
            } else {
                return "en"
            }
        }
    }
    
    // 设置语言
    func setLanguage(_ language: String) {
//        DefaultsManager.shared.set(language, for: .appLanguage)
        // 通知应用语言已更改
        NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
    }
    
    // 获取本地化字符串
    func localizedString(_ key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
}

// 扩展String，添加本地化方法
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(self)
    }
}
