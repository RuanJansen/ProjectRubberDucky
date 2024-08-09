//
//  HomeComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/02.
//

import Foundation
import NeedleFoundation

extension RootComponent {
    public var homeComponent: HomeComponent {
        HomeComponent(parent: self)
    }

    var homeFeatureProvider: any FeatureProvider {
        shared {
            HomeProvider(repository: videoRepository)
        }
    }

    public var searchUsecase: SearchUsecase {
        shared {
            SearchUsecase(provider: homeFeatureProvider as! SearchProvidable)
        }
    }

    public var videoRepository: PexelRepository {
        PexelRepository()
    }
}

class HomeComponent: Component<HomeDependency> {
    var feature: any Feature {
        HomeFeature(featureProvider: featureProvider, searchUsecase: searchUsecase)
    }

    var featureProvider: any FeatureProvider {
        dependency.homeFeatureProvider
    }

    var searchUsecase: SearchUsecase {
        dependency.searchUsecase
    }
}
