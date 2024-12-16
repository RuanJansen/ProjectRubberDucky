//
//  NavigationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/07.
//

import Observation
import SwiftUI
import Combine

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
    
    public func displaySplashScreen() {
        navigationCoordinator.splash(.splashDestination)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.navigationCoordinator.splash = nil
            self.dismissSheet()
            self.addListeners()
        }
    }
    
    public func addListeners() {
        userAuthenticationManager.$isAuthenticated.sink { [self] isAuthenticated in
            pushAuthenticationIfUnauthorised(isAuthenticated: isAuthenticated)
        }
        .store(in: &cancellables)
    }
    
    public func pushAuthenticationIfUnauthorised(isAuthenticated: Bool) {
        if isAuthenticated {
            navigateToHomeTab()
            dismissFullscreenCover()
            pushOnboardingForFirstTime()
        } else {
            navigateToAuthentication()
        }
    }
    
    public func pushOnboardingForFirstTime() {
        if !userDefaultsManager.hasSeenboarding {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                self.navigateToOnboarding()
                self.userDefaultsManager.hasSeenboarding = true
            }
        }
    }
        
    public func navigateToOnboarding() {
        navigationCoordinator.push(.onboardingDestination, type: .sheet)
    }
    
    public func navigateToRoot() {
        navigationCoordinator.popToRoot()
    }
    
    public func navigateToAuthentication() {
        navigationCoordinator.push(.authenticationDestination, type: .fullscreenCover)
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
    
    public func navigateToHomeTab() {
        navigateToTab(index: 0)
    }
    
    private func navigateToTab(index: Int) {
        navigationCoordinator.switchTab(to: index)
    }
}
