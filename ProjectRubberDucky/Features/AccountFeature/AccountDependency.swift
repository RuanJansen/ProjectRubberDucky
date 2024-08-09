//
//  AccountDependency.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import NeedleFoundation

protocol AccountDependency: Dependency {
    var accountProvider: any FeatureProvider { get }
}
