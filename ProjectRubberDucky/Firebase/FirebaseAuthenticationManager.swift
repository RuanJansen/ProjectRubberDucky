//
//  FirebaseAuthenticationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/06.
//

import FirebaseAuth

struct FirebaseUserDataModel {
    let uid: String
    let email: String?
    let photoURL: URL?

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL
    }
}

class FirebaseAuthenticationManager {
    
    func createUser(email: String, password: String) async throws -> FirebaseUserDataModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return FirebaseUserDataModel(user: authDataResult.user)
    }
}
