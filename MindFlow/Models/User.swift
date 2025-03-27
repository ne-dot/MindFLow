import Foundation

struct User: Codable {
    let userId: String
    let username: String
    let email: String?
    let passwordHash: String
    let createdAt: Int
    let updatedAt: Int
    let lastLogin: Int
    let isActive: Bool
    let isAnonymous: Bool
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username
        case email
        case passwordHash = "password_hash"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lastLogin = "last_login"
        case isActive = "is_active"
        case isAnonymous = "is_anonymous"
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