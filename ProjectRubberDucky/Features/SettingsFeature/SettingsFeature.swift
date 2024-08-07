//
//  SettingsFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import Foundation

struct SettingsFeature<Provider>: Feature where Provider: SettingsProvider {
    var featureProvider: any FeatureProvider
    var logoutUsecase: LogoutUsecase
    
    init(featureProvider: any FeatureProvider,
         logoutUsecase: LogoutUsecase) {
        self.featureProvider = featureProvider
        self.logoutUsecase = logoutUsecase
    }

    var featureView: any FeatureView {
        SettingsView(provider: featureProvider as! Provider, logoutUsecase: logoutUsecase)
    }
}
