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
    var searchUsecase: SearchUsecase { get }
}
