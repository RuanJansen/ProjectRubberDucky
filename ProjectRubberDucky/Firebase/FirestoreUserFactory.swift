//
//  FirestoreUserManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/16.
//

import FirebaseFirestore
import FirebaseCore

class FirestoreUserFactory {

    func createUser(user: UserDataModel) async throws {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        try await userRef.setData(createDocumentData(with: user), 
                                      mergeFields: mergeFieldsData(with: user))

    }

    func updateUser(user: UserDataModel) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        userRef.updateData(createDocumentData(with: user))
    }

    private func createDocumentData(with user: UserDataModel) -> [String: Any] {
        return [
            "uid": user.uid,
            "email": user.email as Any,
            "displayName": user.displayName as Any,
            "photoURL": user.photoURL as Any
        ]
    }

    private func mergeFieldsData(with user: UserDataModel) -> [Any] {
        return [
            "uid",
            "email",
            "displayName",
            "photoURL"
        ]
    }

    func deleteUser(user: UserDataModel) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        userRef.delete()
    }
}
