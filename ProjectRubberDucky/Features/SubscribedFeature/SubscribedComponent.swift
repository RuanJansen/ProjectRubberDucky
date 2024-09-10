//
//  SubscribedComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import NeedleFoundation

class SubscribedComponent: Component<SubscribedDependency> {
    public var feature: Feature {
        SubscribedFeature(featureProvider: featureProvider)
    }

    public var featureProvider: any FeatureProvider {
        dependency.subscribedFeatureProvider
    }
}

