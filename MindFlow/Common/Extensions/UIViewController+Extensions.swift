//
//  UIViewController+Extensions.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        
        if let tabBarController = self as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return selected.topMostViewController()
            }
        }
        
        if let navigationController = self as? UINavigationController {
            if let visibleViewController = navigationController.visibleViewController {
                return visibleViewController.topMostViewController()
            }
        }
        
        return self
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}