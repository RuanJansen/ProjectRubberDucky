//
//  FirebaseAuthenticationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/06.
//

import FirebaseAuth

struct UserDataModel {
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

protocol FirebaseProvider {
    func fetchUser() async -> UserDataModel?
    func updateUser(with user: UserDataModel) async throws 
}

class FirebaseAuthenticationManager {
    init(currentUser: UserDataModel? = nil) {
        self.currentUser = currentUser
        self.setupCurrentUser()
    }

    public var currentUser: UserDataModel?

    private func setupCurrentUser(_ user : UserDataModel? = nil) {
        if let user {
            currentUser = user
        } else if let safeCurrent = Auth.auth().currentUser {
            currentUser = UserDataModel(user: safeCurrent)
        }
    }

    func createUser(email: String, password: String, displayName: String? = nil) async -> UserDataModel? {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            var user = UserDataModel(user: authDataResult.user)

            if let displayName {
                user.displayName = displayName
            }

            setupCurrentUser(user)
            return user
        } catch {
            return nil
        }
    }

    func getAuthenticatedUser() throws -> UserDataModel {
        guard let user = Auth.auth().currentUser else {
            // handle error
            throw URLError(.unknown)
        }

        let currentUser = UserDataModel(user: user)

        setupCurrentUser(currentUser)
        return currentUser
    }

    func checkUserIsAuthenticated(completion: @escaping (UserDataModel) -> ()) -> Bool {
        if (Auth.auth().currentUser?.reload()) != nil {
            if let currentUser = Auth.auth().currentUser {
                completion(UserDataModel(user: currentUser))
            }
            return true
        } else {
            return false
        }
    }

    func signIn(email: String, password: String) async -> UserDataModel? {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = UserDataModel(user: authDataResult.user)

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

    public func deleteAccount(completion: @escaping (UserDataModel?) -> ()) {
        #warning("When session expires, reauthenticate the user by invoking reauthenticateWithCredential:completion:")
        guard let currentUser = Auth.auth().currentUser else { return }
        let user = UserDataModel(user: currentUser)
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
        AuthErrors


    }

    public func deleteUser(completion: @escaping (UserDataModel) -> ()) async throws {
        guard let currentUser = Auth.auth().currentUser else { return }
        try await currentUser.delete()
        let user = UserDataModel(user: currentUser)
        completion(user)
    }

    public func reAuthenticate() {
//        let user = Auth.auth().currentUser
//        var credential: AuthCredential
//
//        // Prompt the user to re-provide their sign-in credentials
//
//        user?.reauthenticate(with: credential, completion: { authDataResult, error in
//            if let error = error {
//                // An error happened.
//              } else {
//                // User re-authenticated.
//              }
//        })
    }
}

extension FirebaseAuthenticationManager: FirebaseProvider {
    func fetchUser() -> UserDataModel? {
        if let currentUser = Auth.auth().currentUser {
            return UserDataModel(user: currentUser)
        } else {
            return nil
        }
    }

    func updateUser(with user: UserDataModel) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = user.displayName
        changeRequest?.photoURL = user.photoURL
        try await changeRequest?.commitChanges()
    }
}
