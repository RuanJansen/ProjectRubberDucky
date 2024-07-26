//
//  OnboardingFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import Foundation

class OnboardingFeature<Provider>: Feature where Provider: OnboardingProvider {
    var featureProvider: any FeatureProvider
    var onboardingUsecase: OnboardingUsecase

    init(featureProvider: any FeatureProvider, 
         onboardingUsecase: OnboardingUsecase) {
        self.featureProvider = featureProvider
        self.onboardingUsecase = onboardingUsecase
    }

    var featureView: any FeatureView {
        OnboardingView(provider: featureProvider as! Provider,
                       onboardingUsecase: onboardingUsecase)
    }

    
}
