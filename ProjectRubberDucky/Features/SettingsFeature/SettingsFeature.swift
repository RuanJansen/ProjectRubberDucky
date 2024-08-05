//
//  SettingsFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import Foundation

struct SettingsFeature<Provider>: Feature where Provider: SettingsProvider {
    var featureProvider: any FeatureProvider

    init(featureProvider: any FeatureProvider) {
        self.featureProvider = featureProvider
    }

    var featureView: any FeatureView {
        SettingsView(provider: featureProvider as! Provider)
    }
}
