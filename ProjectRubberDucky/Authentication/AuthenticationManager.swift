import Foundation
import Combine

class AuthenticationMediator: ObservableObject {
    @Published public var isAuthenticated: Bool

    private var authenticateUserManager: AuthenticateUserManager
    private var logoutUserManager : LogOutUserManager
    private var deleteUserManager: DeleteUserManager
    private var cancelabeles: Set<AnyCancellable> = []

    init(authenticateUserManager: AuthenticateUserManager,
         logoutUserManager: LogOutUserManager,
         deleteUserManager: DeleteUserManager) {
        self.isAuthenticated = false

        self.authenticateUserManager = authenticateUserManager
        self.logoutUserManager = logoutUserManager
        self.deleteUserManager = deleteUserManager
    }

    private func addListeners() {
        authenticateUserManager.$isAuthenticated.sink { isAuthenticated in
            self.isAuthenticated = isAuthenticated
        }
        .store(in: &cancelabeles)

        logoutUserManager.$isAuthenticated.sink { isAuthenticated in
            self.isAuthenticated = isAuthenticated
        }
        .store(in: &cancelabeles)

        deleteUserManager.$isAuthenticated.sink { isAuthenticated in
            self.isAuthenticated = isAuthenticated
        }
        .store(in: &cancelabeles)
    }
}

class AuthenticateUserManager: ObservableObject {
    @Published public var isAuthenticated: Bool

    private let firebaseAuthenticationManager: FirebaseAuthenticationManager
    private let firestoreUserFactory: FirestoreUserFactory

    init(firebaseAuthenticationManager: FirebaseAuthenticationManager,
         firestoreUserFactory: FirestoreUserFactory) {
        self.isAuthenticated = false
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
        self.firestoreUserFactory = firestoreUserFactory
        self.updateAuthenticatedUserData()
    }

    public func authenticate() {
        let authUser = try? self.firebaseAuthenticationManager.getAuthenticatedUser()

        if let authUser {
            Task {
                do {
                    try await self.firestoreUserFactory.createUser(user: authUser)
                } catch {
                    print("Failed adding user to FireStore")
                }
            }
            self.isAuthenticated = true
        } else {
            self.isAuthenticated = false
        }
    }

    private func updateAuthenticatedUserData() {
        self.isAuthenticated = firebaseAuthenticationManager.checkUserIsAuthenticated() { user in
            self.firestoreUserFactory.updateUser(user: user)
        }
    }
}

class LogOutUserManager: ObservableObject {
    @Published public var isAuthenticated: Bool

    private let firebaseAuthenticationManager: FirebaseAuthenticationManager
    private let firestoreUserFactory: FirestoreUserFactory

    init(firebaseAuthenticationManager: FirebaseAuthenticationManager,
         firestoreUserFactory: FirestoreUserFactory) {
        self.isAuthenticated = false
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
        self.firestoreUserFactory = firestoreUserFactory
    }

    public func logOut() async {
        do {
            try await firebaseAuthenticationManager.logOut()
            isAuthenticated = false
        } catch {
            isAuthenticated = true
            return
        }
    }
}

class DeleteUserManager: ObservableObject {
    @Published public var isAuthenticated: Bool

    private let firebaseAuthenticationManager: FirebaseAuthenticationManager
    private let firestoreUserFactory: FirestoreUserFactory

    init(firebaseAuthenticationManager: FirebaseAuthenticationManager,
         firestoreUserFactory: FirestoreUserFactory) {
        self.isAuthenticated = false
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
        self.firestoreUserFactory = firestoreUserFactory
    }

    public func deleteAccount(onFailure: @escaping () -> (Void)) {
        firebaseAuthenticationManager.deleteAccount() { user in
            if let user {
                self.firestoreUserFactory.deleteUser(user: user)
                self.isAuthenticated = false
            } else {
                onFailure()
            }
        }
    }

    public func deleteUser() async throws {
        try await firebaseAuthenticationManager.deleteUser() { user in
            self.firestoreUserFactory.deleteUser(user: user)
            self.isAuthenticated = false
        }
    }
}

//class AuthenticationManager: ObservableObject {
//    @Published public var isAuthenticated: Bool
//    var currentNonce: String?
//
//    private let firebaseAuthenticationManager: FirebaseAuthenticationManager
//    private let firestoreUserFactory: FirestoreUserFactory
//
//    init(firebaseAuthenticationManager: FirebaseAuthenticationManager,
//         firestoreUserFactory: FirestoreUserFactory) {
//        self.isAuthenticated = false
//        self.firebaseAuthenticationManager = firebaseAuthenticationManager
//        self.firestoreUserFactory = firestoreUserFactory
//        self.updateAuthenticatedUserData()
//    }
//
//    public func authenticate() {
//        let authUser = try? self.firebaseAuthenticationManager.getAuthenticatedUser()
//
//        if let authUser {
//            Task {
//                do {
//                    try await self.firestoreUserFactory.createUser(user: authUser)
//                } catch {
//                    print("Failed adding user to FireStore")
//                }
//            }
//            self.isAuthenticated = true
//        } else {
//            self.isAuthenticated = false
//        }
//    }
//
//    public func logOut() async {
//        do {
//            try await firebaseAuthenticationManager.logOut()
//            isAuthenticated = false
//        } catch {
//            isAuthenticated = true
//            return
//        }
//    }
//
//    public func deleteAccount(onFailure: @escaping () -> (Void)) {
//        firebaseAuthenticationManager.deleteAccount() { user in
//            if let user {
//                self.firestoreUserFactory.deleteUser(user: user)
//                self.isAuthenticated = false
//            } else {
//                onFailure()
//            }
//        }
//    }
//
//    public func deleteUser() async throws {
//        try await firebaseAuthenticationManager.deleteUser() { user in
//            self.firestoreUserFactory.deleteUser(user: user)
//            self.isAuthenticated = false
//        }
//    }
//
//    private func updateAuthenticatedUserData() {
//        self.isAuthenticated = firebaseAuthenticationManager.checkUserIsAuthenticated() { user in
//            self.firestoreUserFactory.updateUser(user: user)
//        }
//    }
//}






