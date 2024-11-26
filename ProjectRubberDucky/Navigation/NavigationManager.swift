//
//  NavigationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/07.
//

import Observation
import SwiftUI
import Combine

enum NavigationState {
    case main(AnyView, onboardingFeature: AnyView?)
    case authentication(AnyView)
    case splashScreen
}

@Observable
class NavigationManager {
    private var navigationCoordinator: Coordinator<MainCoordinatorViews>
    private let onboardingFeature: any Feature
    private let authenticationFeature: any Feature
    private let userAuthenticationManager: UserAuthenticationManageable
    private let userDefaultsManager: UserDefaultsManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationCoordinator: Coordinator<MainCoordinatorViews>,
         onboardingFeature: any Feature,
         authenticationFeature: any Feature,
         userAuthenticationManager: UserAuthenticationManageable,
         userDefaultsManager: UserDefaultsManager) {
        self.navigationCoordinator = navigationCoordinator
        self.onboardingFeature = onboardingFeature
        self.authenticationFeature = authenticationFeature
        self.userAuthenticationManager = userAuthenticationManager
        self.userDefaultsManager = userDefaultsManager
        self.navigationCoordinator.push(.authentication)
        self.addListeners()
    }
    
    private func addListeners() {
        userAuthenticationManager.getAuthenticationStatus().sink { [self] isAuthenticated in
            if isAuthenticated {
                navigationCoordinator.popToRoot()
                if userDefaultsManager.shouldShowOnboarding {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                        self.navigationCoordinator.push(.onboarding, type: .sheet)
                    }
                }
            } else {
                navigationCoordinator.push(.authentication, type: .fullscreenCover)
            }
        }
        .store(in: &cancellables)
    }
}
