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

    public let userDefaultsManager: UserDefaultsManager
    public var navigationState: NavigationState
    public var showOnboardingSheet: Bool

    private var cancellables = Set<AnyCancellable>()

    init(mainFeature: any Feature, 
         onboardingFeature: any Feature,
         authenticationFeature: any Feature,
         authenticationManager: AuthenticationManager,
         userDefaultsManager: UserDefaultsManager) {
        self.mainFeature = mainFeature
        self.onboardingFeature = onboardingFeature
        self.authenticationFeature = authenticationFeature
        self.authenticationManager = authenticationManager
        self.userDefaultsManager = userDefaultsManager
        self.showOnboardingSheet = false
        self.navigationState = .launchingView
        self.addListeners()
    }

    func fetchContent() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.startAppFlow()
        }
    }

    private func addListeners() {
        authenticationManager.$isAuthenticated.sink { [self] result in
            if result {
                self.navigationState = .mainView(AnyView(self.mainFeature.featureView), onboardingFeature: AnyView(self.onboardingFeature.featureView))
                if userDefaultsManager.shouldShowOnboarding {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                        self.showOnboardingSheet = true
                    }
                }
            }
        }
        .store(in: &cancellables)
    }

    private func startAppFlow()  {
        if userDefaultsManager.isAuthenticated {
            self.navigationState = .mainView(AnyView(mainFeature.featureView), onboardingFeature: AnyView(onboardingFeature.featureView))
        } else {
            self.navigationState = .authenticationView(AnyView(authenticationFeature.featureView))
        }
    }
}
