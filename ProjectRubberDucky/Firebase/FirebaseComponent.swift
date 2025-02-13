//
//  FirebaseComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/21.
//

import Foundation
import NeedleFoundation

extension RootComponent {
    public var firebaseComponent: FirebaseComponent {
        FirebaseComponent(parent: self)
    }
}

protocol FirebaseDependency: Dependency { }

class FirebaseComponent: Component<FirebaseDependency> {
    public var firebaseRemoteConfig: FirebaseRemoteConfigManager {
        shared {
            FirebaseRemoteConfigManager()
        }
    }

    public var userDatabaseManager: FireStoreUserDatabaseManager {
        FireStoreUserDatabaseManager()
    }

    public var firebaseAuthenticationManager: FirebaseUserAuthenticationManager {
        shared {
            FirebaseUserAuthenticationManager()
        }
    }
}
