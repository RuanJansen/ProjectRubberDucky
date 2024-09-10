//
//  OnboardingDependency.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import NeedleFoundation

protocol OnboardingDependency: Dependency {
    var onboardingProvider: any FeatureProvider { get }
    var userDefaultsManager: UserDefaultsManager { get }
}

extension RootComponent {
    public var onboardingComponent: OnboardingComponent {
        OnboardingComponent(parent: self)
    }

    var onboardingProvider: any FeatureProvider {
        shared {
            OnboardingProvider(userDefaultsManager: userDefaultsManager,
                               tabFeatureFlagProvider: tabFeatureFlagProvider)
        }
    }
}
