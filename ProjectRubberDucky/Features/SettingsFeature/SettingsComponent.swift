//
//  SettingsComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import NeedleFoundation

class SettingsComponent: Component<SettingsDependency> {
    public var feature: any Feature {
        SettingsFeature(featureProvider: featureProvider)
    }

    public var featureProvider: any FeatureProvider {
        dependency.settingsFeatureProvider
    }
}
