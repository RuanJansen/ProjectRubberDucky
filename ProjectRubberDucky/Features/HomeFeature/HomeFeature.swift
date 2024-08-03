//
//  HomeFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/02.
//

import Foundation

struct HomeFeature<Provider>: Feature where Provider: HomeProvider {
    var featureProvider: any FeatureProvider
    var searchUsecase: SearchUsecase

    init(featureProvider: any FeatureProvider,
         searchUsecase: SearchUsecase) {
        self.featureProvider = featureProvider
        self.searchUsecase = searchUsecase
    }

    var featureView: any FeatureView {
        HomeView(provider: featureProvider as! Provider, searchUsecase: searchUsecase)
    }
}
