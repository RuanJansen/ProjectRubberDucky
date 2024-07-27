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
        OnboardingProvider(onboardingUsecase: onboardingUsecase)
    }

//    public var onboardingUsecase: OnboardingUsecase {
//        OnboardingUsecase()
//    }
}

class OnboardingComponent: Component<OnboardingDependency> {
    public var feature: Feature {
        OnboardingFeature(featureProvider: featureProvider,
                          onboardingUsecase: onboardingUsecase)
    }

    public var featureProvider: any FeatureProvider {
        dependency.onboardingProvider
    }

    public var onboardingUsecase: OnboardingUsecase {
        dependency.onboardingUsecase
    }
}
