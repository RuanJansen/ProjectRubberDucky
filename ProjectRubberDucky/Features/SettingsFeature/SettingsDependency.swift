//
//  SettingsDependency.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import NeedleFoundation

protocol SettingsDependency: Dependency {
    var settingsFeatureProvider: any FeatureProvider { get }
}
