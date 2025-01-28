//
//  LogoutManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/11/23.
//

import Foundation

protocol LogoutManageable {
    func logOut() async
}

class LogoutManager: LogoutManageable {
    private var userAuthenticationManager: UserAuthenticationManageable
    private let authenticationManager: UserAuthenticationLogoutable
    
    init(userAuthenticationManager: UserAuthenticationManageable,
         authenticationManager: UserAuthenticationLogoutable) {
        self.userAuthenticationManager = userAuthenticationManager
        self.authenticationManager = authenticationManager
    }
    
    func logOut() async {
        do {
            try await authenticationManager.logOut()
            userAuthenticationManager.setAuthenticationStatus(to: false)
            return
        } catch {
            userAuthenticationManager.setAuthenticationStatus(to: true)
        }
    }
}
