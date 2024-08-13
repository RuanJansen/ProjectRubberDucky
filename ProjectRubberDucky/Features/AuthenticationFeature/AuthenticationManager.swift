import Foundation
import Combine
import FirebaseAuth

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
    private let firebaseUserManager: FirebaseUserManager
    private let userDefaultsManager: UserDefaultsManager

    init(firebaseAuthenticationManager: FirebaseAuthenticationManager,
         firebaseUserManager: FirebaseUserManager,
         userDefaultsManager: UserDefaultsManager) {
        self.id = UUID()
        self.isAuthenticated = userDefaultsManager.isAuthenticated
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
        self.firebaseUserManager = firebaseUserManager
        self.userDefaultsManager = userDefaultsManager
    }

    public func createUser(email: String, password: String) async {
        do {
            let newUser = try await firebaseAuthenticationManager.createUser(email: email, password: password)
            try await firebaseUserManager.createUser(with: newUser)
            isAuthenticated = true
        } catch { }
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

    public func signInWithApple() async {
        let authUser = try? firebaseAuthenticationManager.getAuthenticatedUser()

        if let authUser {
            do {
                try await firebaseUserManager.createUser(with: authUser)
                isAuthenticated = true
            } catch { }
        } else {
            isAuthenticated = false
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

    public func deleteAccount() async {
        do {
            try await firebaseAuthenticationManager.deleteAccount()
            isAuthenticated = false
            userDefaultsManager.isAuthenticated = isAuthenticated
        } catch {

        }
    }
}
