//
//  UserServiceManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/06.
//

import FirebaseAuth

struct UserServiceDataModel {
    let uid: String
    let email: String?
    var displayName: String?
    var photoURL: URL?

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL
    }
}

protocol UserAuthenticationAuthenticatable {
    func getAuthenticatedUser() throws -> UserServiceDataModel
    func signInWithApple(idToken idTokenString: String, rawNonce nonce: String, completion: @escaping () -> Void)
    func signIn(email: String, password: String) async -> UserServiceDataModel?
    func checkUserIsAuthenticated(completion: @escaping (UserServiceDataModel) -> ()) -> Bool
}

protocol UserAuthenticationLogoutable {
    func logOut() async throws
}

protocol UserAuthenticationProvideable {
    func fetchUser() async -> UserServiceDataModel?
}

protocol UserAuthenticationUpdateable {
    func updateUser(with user: UserServiceDataModel) async throws
}

protocol UserAuthenticationCreateable {
    func createUser(email: String, password: String, displayName: String?) async -> UserServiceDataModel?
}

protocol UserAuthenticationDeleteable {
    func deleteUser(completion: @escaping (UserServiceDataModel) -> ()) async throws
    func deleteAccount(completion: @escaping (UserServiceDataModel?) -> ())
}

typealias FirebaseUserAuthenticationManageable = UserAuthenticationAuthenticatable & UserAuthenticationLogoutable & UserAuthenticationProvideable & UserAuthenticationUpdateable & UserAuthenticationCreateable & UserAuthenticationDeleteable

class FirebaseUserAuthenticationManager: FirebaseUserAuthenticationManageable {
    
    init(currentUser: UserServiceDataModel? = nil) {
        self.currentUser = currentUser
        self.setupCurrentUser()
    }

    public var currentUser: UserServiceDataModel?

    private func setupCurrentUser(_ user : UserServiceDataModel? = nil) {
        if let user {
            currentUser = user
        } else if let safeCurrent = Auth.auth().currentUser {
            currentUser = UserServiceDataModel(user: safeCurrent)
        }
    }

    func createUser(email: String, password: String, displayName: String? = nil) async -> UserServiceDataModel? {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            var user = UserServiceDataModel(user: authDataResult.user)

            if let displayName {
                user.displayName = displayName
            }

            setupCurrentUser(user)
            return user
        } catch {
            return nil
        }
    }

    func getAuthenticatedUser() throws -> UserServiceDataModel {
        guard let user = Auth.auth().currentUser else {
            // handle error
            throw URLError(.unknown)
        }

        let currentUser = UserServiceDataModel(user: user)

        setupCurrentUser(currentUser)
        return currentUser
    }
    
    func checkUserIsAuthenticated(completion: @escaping (UserServiceDataModel) -> ()) -> Bool {
        if (Auth.auth().currentUser?.reload()) != nil {
            if let currentUser = Auth.auth().currentUser {
                completion(UserServiceDataModel(user: currentUser))
            }
            return true
        } else {
            return false
        }
    }

    func signIn(email: String, password: String) async -> UserServiceDataModel? {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = UserServiceDataModel(user: authDataResult.user)

            setupCurrentUser(user)
            return user
        } catch {
            return nil
        }
    }

    func signInWithApple(idToken idTokenString: String, rawNonce nonce: String, completion: @escaping () -> Void) {
        let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print(error?.localizedDescription as Any)
                return
            }
            print("signed in")
            completion()
        }
    }

    func logOut() async throws {
        try Auth.auth().signOut()
    }

    public func deleteAccount(completion: @escaping (UserServiceDataModel?) -> ()) {
        #warning("When session expires, reauthenticate the user by invoking reauthenticateWithCredential:completion:")
        guard let currentUser = Auth.auth().currentUser else { return }
        let user = UserServiceDataModel(user: currentUser)
        Auth.auth().currentUser?.delete(completion: { error in
            Auth.auth().currentUser?.reload()
            if let error {
                completion(nil)
                print(error.localizedDescription)
            } else {
                completion(user)
                print("User Deleted: ", String(describing: self.currentUser?.email))
            }
        })
    }

    public func deleteUser(completion: @escaping (UserServiceDataModel) -> ()) async throws {
        guard let currentUser = Auth.auth().currentUser else { return }
        try await currentUser.delete()
        let user = UserServiceDataModel(user: currentUser)
        completion(user)
    }

    public func fetchUser() -> UserServiceDataModel? {
        if let currentUser = Auth.auth().currentUser {
            return UserServiceDataModel(user: currentUser)
        } else {
            return nil
        }
    }

    public func updateUser(with user: UserServiceDataModel) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = user.displayName
        changeRequest?.photoURL = user.photoURL
        try await changeRequest?.commitChanges()
    }
}
