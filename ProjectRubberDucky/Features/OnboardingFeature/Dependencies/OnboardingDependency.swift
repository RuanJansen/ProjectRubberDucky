//
//  OnboardingDependency.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import NeedleFoundation

protocol OnboardingDependency: Dependency {
    var onboardingProvider: any FeatureProvider { get }
    var onboardingUsecase: OnboardingUsecase { get }
}
