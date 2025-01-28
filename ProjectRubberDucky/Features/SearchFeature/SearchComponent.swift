//
//  SearchComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/09/10.
//

import Foundation
import NeedleFoundation

class SearchComponent: Component<SearchDependency> {
    var feature: any Feature {
        SearchFeature(featureProvider: featureProvider,
                      searchUsecase: searchUsecase)
    }

    var featureProvider: any FeatureProvider {
        dependency.searchFeatureProvider
    }

    var searchUsecase: SearchUsecase {
        dependency.searchUsecase
    }
}
