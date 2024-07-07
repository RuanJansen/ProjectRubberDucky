//
//  AuthenticationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/07.
//

import Foundation

enum AuthenticationStatus {
    case userAuthenticated
    case userNotAuthenticated
    case userBanned
    case userNotFound
}

class AuthenticationManager {
    private var plexAthenticator: PlexAuthenticatable
    
    init(plexAthenticator: PlexAuthenticatable) {
        self.plexAthenticator = plexAthenticator
    }

    private func getAuthenticationStatus() -> AuthenticationStatus {
        return .userAuthenticated
    }

    public func getIsUserAuthenticated(with username: String? = nil, and password: String? = nil) -> Bool {
        switch getAuthenticationStatus() {
        case .userAuthenticated:
            return true
        case .userNotAuthenticated:
            return false
        case .userBanned:
            return false
        case .userNotFound:
            return false
        }
    }
}
