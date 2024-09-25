//
//  EmailSignInManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/09/25.
//

import Foundation

protocol EmailSignInManager {
    func signIn(email: String, password: String) async throws
}

class ConcreteEmailSignInManager: EmailSignInManager {
    private let authenticateUserManager: AuthenticateUserManager
    private let firebaseAuthenticationManager: FirebaseAuthenticationManager
    private let firestoreUserFactory: FirestoreUserFactory

    init(authenticateUserManager: AuthenticateUserManager, firebaseAuthenticationManager: FirebaseAuthenticationManager, firestoreUserFactory: FirestoreUserFactory) {
        self.authenticateUserManager = authenticateUserManager
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
        self.firestoreUserFactory = firestoreUserFactory
    }

    public func signIn(email: String, password: String) async throws {
        guard let user = await firebaseAuthenticationManager.signIn(email: email, password: password) else { return }
        authenticateUserManager.authenticate()
    }
}
