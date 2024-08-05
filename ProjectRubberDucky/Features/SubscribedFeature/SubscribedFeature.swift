//
//  SubscribedFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct SubscribedFeature<Provider>: Feature where Provider: SubscribedProvider {
    var featureProvider: any FeatureProvider
    
    init(featureProvider: any FeatureProvider) {
        self.featureProvider = featureProvider
    }

    var featureView: any FeatureView {
        SubscribedView(provider: featureProvider as! Provider)
    }

    
}
