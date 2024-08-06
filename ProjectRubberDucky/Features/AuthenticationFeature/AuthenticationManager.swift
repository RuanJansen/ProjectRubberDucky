import Foundation
import Combine

enum AuthenticationStatus {
    case userAuthenticated
    case userNotAuthenticated
    case userNotFound
}

@Observable
class AuthenticationManager {
    private var isAuthenticated: Bool
    private let firebaseAuthenticationManager: FirebaseAuthenticationManager

    init(isAuthenticated: Bool,
         firebaseAuthenticationManager: FirebaseAuthenticationManager) {
        self.isAuthenticated = isAuthenticated
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
    }

    public func createUser(email: String, password: String) async throws -> FirebaseUserDataModel {
        return try await firebaseAuthenticationManager.createUser(email: email, password: password)
    }

    public func login() {
        let authUser = try? firebaseAuthenticationManager.getAuthenticatedUser()

        if let authUser {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }

    
}
