//
//  ErrorHandler.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import Foundation

class ErrorHandler {
    
    static func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .serverError(let message, _):
                ToastView.showError(message: message)
            case .networkError(_):
                ToastView.showError(message: "网络连接失败，请检查网络设置")
            case .decodingError(_):
                ToastView.showError(message: "数据解析错误")
            }
        } else {
            ToastView.showError(message: error.localizedDescription)
        }
    }
}