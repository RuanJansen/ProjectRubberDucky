//
//  EmailSignInManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/11/22.
//

import Foundation

protocol EmailSignInManageable {
    func signIn(email: String, password: String) async throws
}

class EmailSignInManager: EmailSignInManageable {
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

    public func signIn(email: String, password: String) async throws {
        guard let user = await serviceAuthenticationManager.signIn(email: email, password: password) else { return }
        self.userAuthenticationManager.authenticate()
    }
}
