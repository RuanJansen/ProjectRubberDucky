import Foundation
import Combine

enum AuthenticationStatus {
    case userAuthenticated
    case userNotAuthenticated
    case userNotFound
}

//@Observable
class AuthenticationManager: ObservableObject {
    public var id: UUID

    @Published public var isAuthenticated: Bool

    private let firebaseAuthenticationManager: FirebaseAuthenticationManager
    private let userDefaultsManager: UserDefaultsManager

    init(firebaseAuthenticationManager: FirebaseAuthenticationManager,
         userDefaultsManager: UserDefaultsManager) {
        self.id = UUID()
        self.isAuthenticated = userDefaultsManager.isAuthenticated
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
        self.userDefaultsManager = userDefaultsManager
    }

    public func createUser(email: String, password: String) async {
        do {
            let newUser = try await firebaseAuthenticationManager.createUser(email: email, password: password)
            isAuthenticated = true
        } catch {
            login()
        }
        
        userDefaultsManager.isAuthenticated = isAuthenticated
    }

    public func login() {
        let authUser = try? firebaseAuthenticationManager.getAuthenticatedUser()

        if let authUser {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }

        userDefaultsManager.isAuthenticated = isAuthenticated
    }

    public func signIn(email: String, password: String) async throws {
        do {
            let newUser = try await firebaseAuthenticationManager.signIn(email: email, password: password)
            isAuthenticated = true
        } catch {
            login()
        }

        userDefaultsManager.isAuthenticated = isAuthenticated
    }

    public func logOut() async {
        do {
            try await firebaseAuthenticationManager.logOut()
            isAuthenticated = false
            userDefaultsManager.isAuthenticated = isAuthenticated
        } catch {
            isAuthenticated = true
            userDefaultsManager.isAuthenticated = isAuthenticated
            return
        }
    }
}
