//
//  LibraryFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import Foundation

struct LibraryFeature<Provider>: Feature where Provider: LibraryProvider {
    var featureProvider: any FeatureProvider

    init(featureProvider: any FeatureProvider) {
        self.featureProvider = featureProvider
    }

    var featureView: any FeatureView {
        LibraryView(provider: featureProvider as! Provider)
    }

}
