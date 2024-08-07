//
//  OnboardingComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import NeedleFoundation

extension RootComponent {
    public var onboardingComponent: OnboardingComponent {
        OnboardingComponent(parent: self)
    }

    var onboardingProvider: any FeatureProvider {
        shared {
            OnboardingProvider(userDefaultsManager: userDefaultsManager)
        }
    }
}

class OnboardingComponent: Component<OnboardingDependency> {
    public var feature: Feature {
        OnboardingFeature(featureProvider: featureProvider, userDefaultsManager: userDefaultsManager)
    }

    public var featureProvider: any FeatureProvider {
        dependency.onboardingProvider
    }

    public var userDefaultsManager: UserDefaultsManager {
        dependency.userDefaultsManager
    }
}
