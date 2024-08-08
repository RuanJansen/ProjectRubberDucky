//
//  SettingsComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import NeedleFoundation

extension RootComponent {
    public var settingsComponent: SettingsComponent {
        SettingsComponent(parent: self)
    }

    public var settingsFeatureProvider: any FeatureProvider {
        shared {
            SettingsProvider(appMetaData: appMetaData, authenticationManager: authenticationManager, firebaseProvider: firebaseAuthenticationManager)
        }
    }

    public var logoutUsecase: LogoutUsecase {
        LogoutUsecase(provider: settingsFeatureProvider as! LogoutProvider)
    }
}

class SettingsComponent: Component<SettingsDependency> {
    public var feature: any Feature {
        SettingsFeature(featureProvider: featureProvider, 
                        logoutUsecase: logoutUsecase)
    }

    public var featureProvider: any FeatureProvider {
        dependency.settingsFeatureProvider
    }

    public var logoutUsecase: LogoutUsecase {
        dependency.logoutUsecase
    }
}
