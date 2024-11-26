//
//  UserDeleteManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/11/23.
//

import Foundation

protocol UserDeleteManageable {
    func deleteUser() async throws
}

class UserDeleteManager: UserDeleteManageable {
    private var userAuthenticationManager: UserAuthenticationManageable
    private let serviceAuthenticationManager: UserAuthenticationDeleteable
    private let userDatabaseManager: DatabaseUserDeleteable

    init(userAuthenticationManager: UserAuthenticationManageable,
         serviceAuthenticationManager: UserAuthenticationDeleteable,
         userDatabaseManager: DatabaseUserDeleteable) {
        self.userAuthenticationManager = userAuthenticationManager
        self.serviceAuthenticationManager = serviceAuthenticationManager
        self.userDatabaseManager = userDatabaseManager
    }
    
    func deleteUser() async throws {
        try await serviceAuthenticationManager.deleteUser() { user in
            self.userDatabaseManager.deleteUser(user: user)
            self.userAuthenticationManager.setAuthenticationStatus(to: false)
        }
    }
}
