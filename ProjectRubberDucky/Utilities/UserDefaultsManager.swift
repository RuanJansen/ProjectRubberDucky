//
//  OnboardingUsecase.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import SwiftUI


class UserDefaultsManager {
    @AppStorage("hasSeenboarding") var hasSeenboarding: Bool = true
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
}
