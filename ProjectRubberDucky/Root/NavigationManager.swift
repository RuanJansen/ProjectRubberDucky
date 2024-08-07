//
//  NavigationManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/07.
//

import Observation
import SwiftUI

enum NavigationState {
    case mainView(AnyView, onboardingFeature: AnyView?)
    case authenticationView(AnyView)
    case launchingView
}

@Observable
class NavigationManager {
    private let mainFeature: any Feature
    private let onboardingFeature: any Feature
    private let authenticationFeature: any Feature
    private let authenticationManager: AuthenticationManager

    public let onboardingUsecase: OnboardingUsecase
    public var isLaunching: Bool
    public var navigationState: NavigationState

    init(mainFeature: any Feature, 
         onboardingFeature: any Feature,
         authenticationFeature: any Feature,
         authenticationManager: AuthenticationManager,
         onboardingUsecase: OnboardingUsecase) {
        self.mainFeature = mainFeature
        self.onboardingFeature = onboardingFeature
        self.authenticationFeature = authenticationFeature
        self.authenticationManager = authenticationManager
        self.onboardingUsecase = onboardingUsecase
        self.isLaunching = true
        self.navigationState = .launchingView
    }

    func fetch() async {
        if authenticationManager.isAuthenticated {
            await MainActor.run {
                self.navigationState = .mainView(AnyView(mainFeature.featureView), onboardingFeature: AnyView(onboardingFeature.featureView))
            }
        } else {
            await MainActor.run {
                self.navigationState = .authenticationView(AnyView(authenticationFeature.featureView))
            }
        }
    }
}
