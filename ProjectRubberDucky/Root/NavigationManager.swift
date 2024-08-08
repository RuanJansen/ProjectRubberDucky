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
        self.navigationState = .splashScreen
        self.addListeners()
    }

    func fetchContent() async {
        await MainActor.run {
            self.navigationState = .splashScreen
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.startAppFlow()
        }
    }

    private func addListeners() {
        authenticationManager.$isAuthenticated.sink { [self] result in
            if result {
                self.navigationState = .main(AnyView(self.mainFeature.featureView), onboardingFeature: AnyView(self.onboardingFeature.featureView))
                if userDefaultsManager.shouldShowOnboarding {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                        self.showOnboardingSheet = true
                    }
                }
            } else {
                self.navigationState = .authentication(AnyView(authenticationFeature.featureView))
            }
        }
        .store(in: &cancellables)
    }

    private func startAppFlow()  {
        if userDefaultsManager.isAuthenticated {
            self.navigationState = .main(AnyView(mainFeature.featureView), onboardingFeature: AnyView(onboardingFeature.featureView))
        } else {
            self.navigationState = .authentication(AnyView(authenticationFeature.featureView))
        }
    }
}
