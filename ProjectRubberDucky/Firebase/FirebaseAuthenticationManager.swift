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
    let displayName: String?
    let photoURL: URL?

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL
    }
}

protocol FirebaseProvider {
    func fetchUser() async -> UserDataModel?
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

        return UserDataModel(user: user)
    }

    func signIn(email: String, password: String) async throws -> UserDataModel  {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = UserDataModel(user: authDataResult.user)

        setupCurrentUser(user)
        return user
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
}
