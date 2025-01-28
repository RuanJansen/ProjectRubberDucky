//
//  AccountFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import Foundation

class AccountFeature<Provider>: Feature where Provider: AccountProvider {
    var featureProvider: any FeatureProvider

    init(featureProvider: any FeatureProvider) {
        self.featureProvider = featureProvider
    }

    var featureView: any FeatureView {
        AccountView(provider: featureProvider as! Provider)
    }
}
