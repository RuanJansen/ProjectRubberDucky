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

    func createUser(email: String, password: String) async throws -> UserDataModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = UserDataModel(user: authDataResult.user)
        setupCurrentUser(user)
        return user
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

    func signIn(email: String, password: String) async throws -> UserDataModel  {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = UserDataModel(user: authDataResult.user)

        setupCurrentUser(user)
        return user
    }

    func signInWithApple(idToken idTokenString: String, rawNonce nonce: String, completion: @escaping () -> Void) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
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

    public func deleteAccount() async throws {
        try await Auth.auth().currentUser?.delete()
    }
}

extension FirebaseAuthenticationManager: FirebaseProvider {
    func fetchUser() async -> UserDataModel? {
        currentUser
    }

    func updateUser(with user: UserDataModel) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = user.displayName
        changeRequest?.photoURL = user.photoURL
        try await changeRequest?.commitChanges()
    }
}
