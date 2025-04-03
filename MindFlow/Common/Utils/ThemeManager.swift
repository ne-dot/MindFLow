//
//  ThemeManager.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit

enum ThemeMode {
    case light
    case dark
    case system
}

class ThemeManager {
    
    static let shared = ThemeManager()
    
    // 颜色配置
    private var lightColors: [String: String] = [:]
    private var darkColors: [String: String] = [:]
    
    private init() {
        // 加载颜色配置
        loadColorConfigurations()
        
        // 初始化时根据系统设置当前主题
        updateThemeBasedOnSystemSettings()
        
        // 监听系统主题变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateThemeBasedOnSystemSettings),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    // 加载颜色配置
    private func loadColorConfigurations() {
        guard let path = Bundle.main.path(forResource: "colors", ofType: "json") else {
            print("无法找到颜色配置文件")
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let lightConfig = json?["light"] as? [String: String] {
                lightColors = lightConfig
            }
            
            if let darkConfig = json?["dark"] as? [String: String] {
                darkColors = darkConfig
            }
        } catch {
            print("加载颜色配置失败: \(error)")
        }
    }
    
    // 当前主题模式
    private var _themeMode: ThemeMode = .system
    var themeMode: ThemeMode {
        get {
            return _themeMode
        }
        set {
            _themeMode = newValue
            notifyThemeChanged()
        }
    }
    
    // 当前是否是暗色模式
    var isDarkMode: Bool {
        switch themeMode {
        case .light:
            return false
        case .dark:
            return true
        case .system:
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
    }
    
    // 获取颜色
    private func getColor(for key: String) -> UIColor {
        let hexColor = isDarkMode ? darkColors[key] : lightColors[key]
        return UIColor(hex: hexColor ?? "#000000")
    }

    // 获取当前主题的颜色
    var primaryColor: UIColor { getColor(for: "primaryColor") }
    var onPrimaryColor: UIColor { getColor(for: "onPrimaryColor") }
    var secondaryColor: UIColor { getColor(for: "secondaryColor") }
    var backgroundColor: UIColor { getColor(for: "backgroundColor") }
    var secondaryBackgroundColor: UIColor { getColor(for: "secondaryBackgroundColor") }
    var onBackgroundColor: UIColor { getColor(for: "onBackgroundColor") }
    var surfaceColor: UIColor { getColor(for: "surfaceColor")}
    var onSurfaceColor: UIColor { getColor(for: "onSurfaceColor")}
    var secondaryTextColor: UIColor { getColor(for: "secondaryTextColor") }
    var buttonTextColor: UIColor { getColor(for: "buttonTextColor") }
    var errorColor: UIColor {getColor(for: "errorColor")}
    var onErrorColor: UIColor {getColor(for: "onErrorColor")}
    var tabBarInactiveTintColor: UIColor {getColor(for: "tabBarInactiveTintColor")}
    var searchBackgroundColor: UIColor {getColor(for: "searchBackgroundColor")}
    var searchTextColor: UIColor {getColor(for: "searchTextColor")}
    var searchPlaceholderColor: UIColor {getColor(for: "searchPlaceholderColor")}
    var searchBorderColor: UIColor {getColor(for: "searchBorderColor")}
    var borderColor: UIColor {getColor(for: "borderColor")}
    var cardShadowColor: UIColor {getColor(for: "cardShadowColor")}
    var buttonShadowColor: UIColor {getColor(for: "buttonShadowColor")}
    var textColor: UIColor {getColor(for: "textColor")}
    var toastSuccessColor: UIColor {getColor(for: "toastSuccessColor")}
    var toastErrorColor: UIColor {getColor(for: "toastErrorColor")}
    var toastInfoColor: UIColor {getColor(for: "toastInfoColor")}
    var toastTextColor: UIColor {getColor(for: "toastTextColor")}
    
     
//    var textBackground: UIColor { getColor(for: "textBackground") }
//    var text: UIColor { getColor(for: "text") }
//    var subText: UIColor { getColor(for: "subText") }
//    var searchBackground: UIColor { getColor(for: "searchBackground") }
//    var searchText: UIColor { getColor(for: "searchText") }
//    var searchPlaceholder: UIColor { getColor(for: "searchPlaceholder") }
//    var iconColor: UIColor { getColor(for: "iconColor") }
//    var tabBarBackground: UIColor { getColor(for: "tabBarBackground") }
//    var border: UIColor { getColor(for: "border") }
//    var cardBackground: UIColor { getColor(for: "cardBackground") }
//    var cardShadow: UIColor { getColor(for: "cardShadow") }
    
    // 主题变化通知
    private let themeChangedNotification = Notification.Name("ThemeChangedNotification")
    
    // 切换主题
    func toggleTheme() {
        themeMode = isDarkMode ? .light : .dark
    }
    
    // 根据系统设置更新主题
    @objc private func updateThemeBasedOnSystemSettings() {
        if themeMode == .system {
            notifyThemeChanged()
        }
    }
    
    // 发送主题变化通知
    private func notifyThemeChanged() {
        NotificationCenter.default.post(name: themeChangedNotification, object: nil)
    }
    
    // 添加主题变化监听
    func addThemeChangeObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: themeChangedNotification,
            object: nil
        )
    }
    
    // 移除主题变化监听
    func removeThemeChangeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(
            observer,
            name: themeChangedNotification,
            object: nil
        )
    }
}

// UIColor扩展，支持十六进制颜色
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}



let theme = ThemeManager.shared
