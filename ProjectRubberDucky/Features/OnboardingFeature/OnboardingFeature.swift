//
//  OnboardingFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import Foundation

class OnboardingFeature<Provider>: Feature where Provider: OnboardingProvider {
    var featureProvider: any FeatureProvider

    init(featureProvider: any FeatureProvider) {
        self.featureProvider = featureProvider
    }

    var featureView: any FeatureView {
        OnboardingView(provider: featureProvider as! Provider)
    }

}
