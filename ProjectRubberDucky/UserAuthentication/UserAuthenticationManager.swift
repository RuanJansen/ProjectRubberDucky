//
//  UserAuthenticationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/11/23.
//

import Foundation
import Combine

protocol UserAuthenticationManageable {
    func authenticate()
    func getAuthenticationStatus() -> AnyPublisher<Bool, Never>
    func setAuthenticationStatus(to isAuthenticated: Bool)
}

class UserAuthenticationManager: UserAuthenticationManageable {
    public var isAuthenticated: Bool = false {
        didSet {
            print(self.isAuthenticated)
        }
    }
    
    private let serviceAuthenticationManager: UserAuthenticationAuthenticatable
    private let userDatabaseManager: DatabaseUserCreateUpdateable

    init(serviceAuthenticationManager: UserAuthenticationAuthenticatable,
         userDatabaseManager: DatabaseUserCreateUpdateable) {
        self.serviceAuthenticationManager = serviceAuthenticationManager
        self.userDatabaseManager = userDatabaseManager
        self.updateAuthenticatedUserData()
    }
    
    public func authenticate() {
        let authUser = try? self.serviceAuthenticationManager.getAuthenticatedUser()
        
        if let authUser {
            Task {
                do {
                    try await self.userDatabaseManager.createUser(user: authUser)
                } catch {
                    print("Failed adding user to FireStore")
                }
            }
            self.isAuthenticated = true
        } else {
            self.isAuthenticated = false
        }
    }
    
    func getAuthenticationStatus() -> AnyPublisher<Bool, Never> {
        return Just(self.isAuthenticated).eraseToAnyPublisher()
    }
    
    func setAuthenticationStatus(to isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }
    
    
    private func updateAuthenticatedUserData() {
        self.isAuthenticated = serviceAuthenticationManager.checkUserIsAuthenticated() { user in
            self.userDatabaseManager.updateUser(user: user)
        }
    }
}
