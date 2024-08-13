//
//  FirebaseUserManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/12.
//

import Foundation
import FirebaseFirestore

struct UserCodableModel: Codable {
    let uid: String
    let email: String?
    var displayName: String?
    var photoURL: URL?

    init(user: UserAuthDataModel) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL
    }
}

class FirebaseUserManager {

    init() { }

    func createUser(with user: UserAuthDataModel) async throws {
        var documentData: [String : Any] = [
            "uid": user.uid,

            "dateCreated": Timestamp()
        ]

        if let email = user.email {
            documentData["email"] = email
        }

        if let displayName = user.displayName {
            documentData["displayName"] = displayName
        }

        if let photoURL = user.photoURL {
            documentData["photoURL"] = photoURL
        }

        let ref = try await Firestore.firestore().collection("users").addDocument(data: documentData)
        print("Document added with ID: \(ref.documentID)")
    }
}
