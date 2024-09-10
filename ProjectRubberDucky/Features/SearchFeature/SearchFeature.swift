//
//  SearchFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/09/10.
//

import Foundation

struct SearchFeature<Provider>: Feature where Provider: SearchProvider {
    var featureProvider: any FeatureProvider
    var searchUsecase: SearchUsecase

    init(featureProvider: any FeatureProvider,
         searchUsecase: SearchUsecase) {
        self.featureProvider = featureProvider
        self.searchUsecase = searchUsecase

    }

    var featureView: any FeatureView {
        SearchView(provider: featureProvider as! Provider, searchUsecase: searchUsecase)
    }
}
