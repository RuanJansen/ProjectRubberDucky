//
//  SubscribedDependency.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import NeedleFoundation

protocol SubscribedDependency: Dependency {
    var subscribedFeatureProvider: any FeatureProvider { get }
}
