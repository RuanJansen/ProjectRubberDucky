//
//  FirebaseAuthenticationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/06.
//

import FirebaseAuth

struct UserAuthDataModel {
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
    func fetchUser() async -> UserAuthDataModel?
    func updateUser(with user: UserAuthDataModel) async throws 
}

class FirebaseAuthenticationManager {
    init(currentUser: UserAuthDataModel? = nil) {
        self.currentUser = currentUser
        self.setupCurrentUser()
    }

    public var currentUser: UserAuthDataModel?

    private func setupCurrentUser(_ user : UserAuthDataModel? = nil) {
        if let user {
            currentUser = user
        } else if let safeCurrent = Auth.auth().currentUser {
            currentUser = UserAuthDataModel(user: safeCurrent)
        }
    }

    func createUser(email: String, password: String) async throws -> UserAuthDataModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = UserAuthDataModel(user: authDataResult.user)
        setupCurrentUser(user)
        return user
    }

    func getAuthenticatedUser() throws -> UserAuthDataModel {
        guard let user = Auth.auth().currentUser else {
            // handle error
            throw URLError(.unknown)
        }

        let currentUser = UserAuthDataModel(user: user)

        setupCurrentUser(currentUser)
        return currentUser
    }

    func signIn(email: String, password: String) async throws -> UserAuthDataModel  {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = UserAuthDataModel(user: authDataResult.user)

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
    func fetchUser() async -> UserAuthDataModel? {
        currentUser
    }

    func updateUser(with user: UserAuthDataModel) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = user.displayName
        changeRequest?.photoURL = user.photoURL
        try await changeRequest?.commitChanges()
    }
}
