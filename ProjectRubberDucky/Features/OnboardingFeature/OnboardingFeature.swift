//
//  OnboardingFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import Foundation

class OnboardingFeature<Provider>: Feature where Provider: OnboardingProvider {
    var featureProvider: any FeatureProvider
    var userDefaultsManager: UserDefaultsManager

    init(featureProvider: any FeatureProvider, 
         userDefaultsManager: UserDefaultsManager) {
        self.featureProvider = featureProvider
        self.userDefaultsManager = userDefaultsManager
    }

    var featureView: any FeatureView {
        OnboardingView(provider: featureProvider as! Provider,
                       userDefaultsManager: userDefaultsManager)
    }

}
