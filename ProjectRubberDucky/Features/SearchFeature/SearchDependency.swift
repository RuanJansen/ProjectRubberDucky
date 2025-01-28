//
//  SearchDependency.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/09/10.
//

import Foundation
import NeedleFoundation


protocol SearchDependency: Dependency {
    var searchFeatureProvider: any FeatureProvider { get }
    var searchUsecase: SearchUsecase { get }
}

extension RootComponent {
    public var searchComponent: SearchComponent {
        SearchComponent(parent: self)
    }

    var searchFeatureProvider: any FeatureProvider {
        shared {
            SearchProvider()
        }
    }

    public var searchUsecase: SearchUsecase {
        shared {
            SearchUsecase(repository: videoRepository)
        }
    }
}
