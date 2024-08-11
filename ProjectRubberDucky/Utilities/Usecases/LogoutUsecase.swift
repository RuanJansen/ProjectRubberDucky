//
//  LogoutUsecase.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/07.
//

import Observation

@Observable
class LogoutUsecase {
    private var provider: LogoutProvidable

    init(provider: LogoutProvidable) {
        self.provider = provider
    }

    public func LogOut() async {
        await provider.logOut()
    }
}
