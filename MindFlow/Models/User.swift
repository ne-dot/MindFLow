//
//  User.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import Foundation

struct User: Codable {
    let userId: String
    let username: String
    let email: String
    let createdAt: TimeInterval
    let lastLogin: TimeInterval
    let isAnonymous: Bool
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username
        case email
        case createdAt = "created_at"
        case lastLogin = "last_login"
        case isAnonymous = "is_anonymous"
    }
    
    // 格式化的创建时间
    var formattedCreatedAt: String {
        let date = Date(timeIntervalSince1970: createdAt)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // 格式化的最后登录时间
    var formattedLastLogin: String {
        let date = Date(timeIntervalSince1970: lastLogin)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct AnonymousLoginResponse: Codable {
    let success: Bool
    let message: String
    let data: AnonymousLoginData
}

struct AnonymousLoginData: Codable {
    let user: User
    let anonymousId: String
    
    enum CodingKeys: String, CodingKey {
        case user
        case anonymousId = "anonymous_id"
    }
}