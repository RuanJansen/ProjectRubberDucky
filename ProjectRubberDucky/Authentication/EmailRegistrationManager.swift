//
//  EmailRegistrationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/09/25.
//

import Foundation

protocol EmailRegistrationManager {
    func createUser(email: String, password: String, displayName: String) async
}

class ConcreteEmailRegistrationManager: EmailRegistrationManager {
    private let authenticateUserManager: AuthenticateUserManager
    private let deleteUserManager: DeleteUserManager
    private let firebaseAuthenticationManager: FirebaseAuthenticationManager
    private let firestoreUserFactory: FirestoreUserFactory

    init(authenticateUserManager: AuthenticateUserManager, deleteUserManager: DeleteUserManager, firebaseAuthenticationManager: FirebaseAuthenticationManager, firestoreUserFactory: FirestoreUserFactory) {
        self.authenticateUserManager = authenticateUserManager
        self.deleteUserManager = deleteUserManager
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
        self.firestoreUserFactory = firestoreUserFactory
    }

    public func createUser(email: String, password: String, displayName: String) async {
        guard let user = await firebaseAuthenticationManager.createUser(email: email, password: password, displayName: displayName) else { return }
        do {
            try await firestoreUserFactory.createUser(user: user)
            authenticateUserManager.isAuthenticated = true
        } catch {
            deleteUserManager.isAuthenticated = false
            deleteUserManager.deleteAccount { }
        }
    }
}
