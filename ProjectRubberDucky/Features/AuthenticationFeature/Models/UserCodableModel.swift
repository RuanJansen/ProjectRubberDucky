//
//  UserModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/18.
//

import Foundation

// MARK: - User
struct UserCodableModel: Codable {
    let user: UserInfoCodableModel
}

// MARK: - UserClass
struct UserInfoCodableModel: Codable {
    let id: Int
    let uuid, email: String
    let joinedAt: Date
    let username, title: String
    let thumb: String
    let hasPassword: Bool
    let authToken, authenticationToken: String
    let confirmedAt: Date
    let rememberMe: Bool

    enum CodingKeys: String, CodingKey {
        case id, uuid, email
        case joinedAt = "joined_at"
        case username, title, thumb, hasPassword, authToken
        case authenticationToken = "authentication_token"
        case confirmedAt
        case rememberMe
    }
}
