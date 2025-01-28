//
//  OnboardingComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import NeedleFoundation

class OnboardingComponent: Component<OnboardingDependency> {
    public var feature: Feature {
        OnboardingFeature(featureProvider: featureProvider)
    }

    public var featureProvider: any FeatureProvider {
        dependency.onboardingProvider
    }
}
