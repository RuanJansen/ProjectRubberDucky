//
//  HomeFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/02.
//

import Foundation

struct HomeFeature<Provider>: Feature where Provider: HomeProvider {
    var featureProvider: any FeatureProvider

    init(featureProvider: any FeatureProvider) {
        self.featureProvider = featureProvider
    }

    var featureView: any FeatureView {
        HomeView(provider: featureProvider as! Provider)
    }
}
