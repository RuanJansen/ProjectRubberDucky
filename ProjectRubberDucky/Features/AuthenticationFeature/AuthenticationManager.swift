import Foundation
import Combine

enum AuthenticationStatus {
    case userAuthenticated
    case userNotAuthenticated
    case userNotFound
}

@Observable
class AuthenticationManager {
    public var isAuthenticated: Bool 

    private let firebaseAuthenticationManager: FirebaseAuthenticationManager

    init(firebaseAuthenticationManager: FirebaseAuthenticationManager) {
        self.isAuthenticated = true
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
    }

    public func createUser(email: String, password: String) async throws -> FirebaseUserDataModel {
        isAuthenticated = true
        return try await firebaseAuthenticationManager.createUser(email: email, password: password)
    }

    public func login() {
//        let authUser = try? firebaseAuthenticationManager.getAuthenticatedUser()
//
//        if let authUser {
//            isAuthenticated = true
//        } else {
//            isAuthenticated = false
//        }
        isAuthenticated = true
    }
}
