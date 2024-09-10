//
//  HomeComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/02.
//

import Foundation
import NeedleFoundation

class HomeComponent: Component<HomeDependency> {
    var feature: any Feature {
        HomeFeature(featureProvider: featureProvider)
    }

    var featureProvider: any FeatureProvider {
        dependency.homeFeatureProvider
    }
}
