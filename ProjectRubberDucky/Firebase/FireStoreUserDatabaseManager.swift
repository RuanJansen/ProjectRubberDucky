//
//  FirestoreUserManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/16.
//

import FirebaseFirestore
import FirebaseCore

protocol DatabaseUserCreateable {
    func createUser(user: UserServiceDataModel) async throws
}

protocol DatabaseUserUpdateable {
    func updateUser(user: UserServiceDataModel)
}

protocol DatabaseUserDeleteable {
    func deleteUser(user: UserServiceDataModel)
}

typealias UserDatabaseManageable = DatabaseUserCreateable & DatabaseUserUpdateable & DatabaseUserDeleteable

class FireStoreUserDatabaseManager: UserDatabaseManageable {
    
    let databaseName = "users"
    
    func createUser(user: UserServiceDataModel) async throws {
        let db = Firestore.firestore()
        let userRef = db.collection(databaseName).document(user.uid)
        try await userRef.setData(createDocumentData(with: user),
                                      mergeFields: mergeFieldsData(with: user))

    }

    func updateUser(user: UserServiceDataModel) {
        let db = Firestore.firestore()
        let userRef = db.collection(databaseName).document(user.uid)
        userRef.updateData(createDocumentData(with: user))
    }

    private func createDocumentData(with user: UserServiceDataModel) -> [String: Any] {
        return [
            "uid": user.uid,
            "email": user.email as Any,
            "displayName": user.displayName as Any,
            "photoURL": user.photoURL as Any
        ]
    }

    private func mergeFieldsData(with user: UserServiceDataModel) -> [Any] {
        return [
            "uid",
            "email",
            "displayName",
            "photoURL"
        ]
    }

    func deleteUser(user: UserServiceDataModel) {
        let db = Firestore.firestore()
        let userRef = db.collection(databaseName).document(user.uid)
        userRef.delete()
    }
}
