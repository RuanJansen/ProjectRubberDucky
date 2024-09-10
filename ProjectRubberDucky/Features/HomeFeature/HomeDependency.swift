//
//  HomeDependency.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/02.
//

import Foundation
import NeedleFoundation

protocol HomeDependency: Dependency {
    var homeFeatureProvider: any FeatureProvider { get }
}

extension RootComponent {
    public var homeComponent: HomeComponent {
        HomeComponent(parent: self)
    }

    var homeFeatureProvider: any FeatureProvider {
        shared {
            HomeProvider(contentProvider: homeContentProvider, repository: videoRepository)
        }
    }

    public var videoRepository: PexelRepository {
        PexelRepository()
    }

    public var homeContentProvider: HomeContentProvidable {
        HomeContentProvider(contentFetcher: contentFetcher)
    }
}
