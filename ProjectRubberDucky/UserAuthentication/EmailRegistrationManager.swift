//
//  EmailRegistrationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/11/22.
//

import Foundation

protocol EmailRegistrationManageable {
    func createUser(email: String, password: String, displayName: String) async
}

class EmailRegistrationManager: EmailRegistrationManageable {
    private var userAuthenticationManager: UserAuthenticationManageable
    private let serviceAuthenticationManager: UserAuthenticationCreateable
    private let userDatabaseManager: DatabaseUserCreateable

    init(userAuthenticationManager: UserAuthenticationManageable,
         serviceAuthenticationManager: UserAuthenticationCreateable,
         userDatabaseManager: DatabaseUserCreateable) {
        self.userAuthenticationManager = userAuthenticationManager
        self.serviceAuthenticationManager = serviceAuthenticationManager
        self.userDatabaseManager = userDatabaseManager
    }
    
    public func createUser(email: String, password: String, displayName: String) async {
        guard let user = await serviceAuthenticationManager.createUser(email: email, password: password, displayName: displayName) else { return }
        do {
            try await userDatabaseManager.createUser(user: user)
            userAuthenticationManager.setAuthenticationStatus(to: true)
        } catch {
            userAuthenticationManager.setAuthenticationStatus(to: false)
        }
    }
}
