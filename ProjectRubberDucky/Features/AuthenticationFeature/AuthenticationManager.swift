//
//  AuthenticationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/07.
//

import Foundation
import Combine

enum AuthenticationStatus {
    case userAuthenticated
    case userNotAuthenticated
    case userBanned
    case userNotFound
}

class AuthenticationManager: ObservableObject {
    private var plexAthenticator: PlexAuthenticatable
    
    @Published var userIsAuthenticated: Bool

    init(plexAthenticator: PlexAuthenticatable) {
        self.plexAthenticator = plexAthenticator
        self.userIsAuthenticated = false
    }

    public func authenticatedUser(with username: String? = nil, and password: String? = nil) {
        if let username,
           let password,
           !username.isEmpty || !password.isEmpty {
            plexAthenticator.authenticateUser(with: username, and: password) { isAuthenticated in
                self.userIsAuthenticated = isAuthenticated
            }
        } else {
            plexAthenticator.authenticateUser(with: PlexAuthentication.ruan.username, and: PlexAuthentication.ruan.password) { isAuthenticated in
                self.userIsAuthenticated = isAuthenticated
            }
        }
    }

    public func getUserAuthenticated() -> AnyPublisher<Bool, Never> {
        $userIsAuthenticated.eraseToAnyPublisher()
    }
}
