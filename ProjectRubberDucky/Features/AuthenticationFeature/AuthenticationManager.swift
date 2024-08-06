import Foundation
import Combine

enum AuthenticationStatus {
    case userAuthenticated
    case userNotAuthenticated
    case userNotFound
}

@Observable
class AuthenticationManager {
    private var plexAthenticator: PlexAuthenticatable
    private var isAuthenticated: Bool

    init(isAuthenticated: Bool,
         plexAthenticator: PlexAuthenticatable) {
        self.isAuthenticated = isAuthenticated
        self.plexAthenticator = plexAthenticator
    }

    public func authenticatedUser(with username: String? = nil, and password: String? = nil) async {
        if let username,
           let password,
           !username.isEmpty || !password.isEmpty {
            await plexAthenticator.authenticateUser(with: username, and: password) { isAuthenticated, token  in
                self.isAuthenticated = isAuthenticated
            }
        } else {
            await plexAthenticator.authenticateUser(with: PlexAuthentication.ruan.username, and: PlexAuthentication.ruan.password) { isAuthenticated, token in
                self.isAuthenticated = isAuthenticated
            }
        }
    }
}
