//
//  LoginManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/11/23.
//

import Foundation

protocol LoginManageable {
    func login()
}

typealias DatabaseUserCreateUpdateable =  DatabaseUserCreateable & DatabaseUserUpdateable

class LoginManager: LoginManageable {
    private var userAuthenticationManager: UserAuthenticationManageable
    private let serviceAuthenticationManager: UserAuthenticationAuthenticatable
    private let userDatabaseManager: DatabaseUserCreateable

    init(userAuthenticationManager: UserAuthenticationManageable,
         serviceAuthenticationManager: UserAuthenticationAuthenticatable,
         userDatabaseManager: DatabaseUserCreateable) {
        self.userAuthenticationManager = userAuthenticationManager
        self.serviceAuthenticationManager = serviceAuthenticationManager
        self.userDatabaseManager = userDatabaseManager
    }
    
    func login() {
        let authUser = try? self.serviceAuthenticationManager.getAuthenticatedUser()

        if let authUser {
            Task {
                do {
                    try await self.userDatabaseManager.createUser(user: authUser)
                } catch {
                    print("Failed adding user to FireStore")
                }
            }
            self.userAuthenticationManager.setAuthenticationStatus(to: true)
        } else {
            self.userAuthenticationManager.setAuthenticationStatus(to: false)
        }
    }
}
