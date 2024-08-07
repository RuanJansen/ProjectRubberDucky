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

    public let onboardingUsecase: OnboardingUsecase
    public var navigationState: NavigationState

    private var cancellables = Set<AnyCancellable>()

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
            print("NavigationManager/addListeners() - authenticationManager.id:\(authenticationManager.id)")

            if result {
                self.navigationState = .mainView(AnyView(self.mainFeature.featureView), onboardingFeature: AnyView(self.onboardingFeature.featureView))
            }
        }
        .store(in: &cancellables)
    }

    private func startAppFlow()  {
        if authenticationManager.isAuthenticated {
            print("NavigationManager/startAppFlow() - authenticationManager.id:\(authenticationManager.id)")
            self.navigationState = .mainView(AnyView(mainFeature.featureView), onboardingFeature: AnyView(onboardingFeature.featureView))
        } else {
            print("NavigationManager/startAppFlow() - authenticationManager.id:\(authenticationManager.id)")
            self.navigationState = .authenticationView(AnyView(authenticationFeature.featureView))
        }
    }
}
