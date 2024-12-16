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
    private var navigationCoordinator: Coordinator<MainCoordinatorDestination>
    private let onboardingFeature: any Feature
    private let authenticationFeature: any Feature
    private let userAuthenticationManager: UserAuthenticationManager
    private let userDefaultsManager: UserDefaultsManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationCoordinator: Coordinator<MainCoordinatorDestination>,
         onboardingFeature: any Feature,
         authenticationFeature: any Feature,
         userAuthenticationManager: UserAuthenticationManager,
         userDefaultsManager: UserDefaultsManager) {
        self.navigationCoordinator = navigationCoordinator
        self.onboardingFeature = onboardingFeature
        self.authenticationFeature = authenticationFeature
        self.userAuthenticationManager = userAuthenticationManager
        self.userDefaultsManager = userDefaultsManager
    }
    
    public func addListeners() {
        userAuthenticationManager.$isAuthenticated.sink { [self] isAuthenticated in
            pushAuthenticationIfUnauthorised(isAuthenticated: isAuthenticated)
            if isAuthenticated {
                pushOnboardingForFirstTime(hasSeenboarding: userDefaultsManager.hasSeenboarding)
            }
        }
        .store(in: &cancellables)
    }
    
    public func pushOnboardingForFirstTime(hasSeenboarding: Bool) {
        if !hasSeenboarding {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                self.navigateToOnboarding()
                self.userDefaultsManager.hasSeenboarding = true
            }
        }
    }
    
    public func pushAuthenticationIfUnauthorised(isAuthenticated: Bool) {
        navigateToHome()
        if isAuthenticated {
            dismissFullscreenCover()
        } else {
            navigateToAuthentication()
        }
    }
        
    public func navigateToOnboarding() {
        navigationCoordinator.push(.onboarding, type: .sheet)
    }
    
    public func navigateToHome() {
        navigationCoordinator.popToRoot()
    }
    
    public func navigateToAuthentication() {
        navigationCoordinator.push(.authentication, type: .fullscreenCover)
    }
    
    public func dismissLink() {
        navigationCoordinator.pop()
    }
    
    public func dismissAll() {
        navigationCoordinator.popToRoot()
    }
    
    public func dismissFullscreenCover() {
        navigationCoordinator.pop(type: .fullscreenCover)
    }
    
    public func dismissSheet() {
        navigationCoordinator.pop(type: .sheet)
    }
}
