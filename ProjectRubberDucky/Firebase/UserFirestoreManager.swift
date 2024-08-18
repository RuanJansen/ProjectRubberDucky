//
//  UserFirestoreManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/16.
//

import FirebaseFirestore
import FirebaseCore

class UserFirestoreManager {

    func createUser(user: UserDataModel) async {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        do {
            try await userRef.setData(createDocumentData(with: user), 
                                      mergeFields: mergeFieldsData(with: user))
        } catch {
            print("Firestore Error")
        }
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
            "displayName",
            "photoURL"
        ]
    }
}
