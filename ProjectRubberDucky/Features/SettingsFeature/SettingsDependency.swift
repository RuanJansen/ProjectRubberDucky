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

extension RootComponent {
    public var settingsComponent: SettingsComponent {
        SettingsComponent(parent: self)
    }

    public var settingsFeatureProvider: any FeatureProvider {
        shared {
            SettingsProvider(contentProvider: settingsContentProvider, appMetaData: appMetaData, logoutManager: userLogoutManager, firebaseProvider: firebaseComponent.firebaseAuthenticationManager, accountView: accountComponent.feature.featureView)
        }
    }

    public var settingsContentProvider: SettingsContentProvidable {
        SettingsContentProvider(contentFetcher: contentFetcher)
    }
}
