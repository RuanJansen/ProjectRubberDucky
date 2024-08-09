//
//  SettingsFeatureProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import Observation
import SwiftUI

@Observable
class SettingsProvider: FeatureProvider {
    typealias DataModel = SettingsDataModel

    var viewState: ViewState<SettingsDataModel>

    private var appMetaData: AppMetaData
    private var authenticationManager: AuthenticationManager
    private let firebaseProvider: FirebaseProvider?

    private var currentUser: UserDataModel?

    init(appMetaData: AppMetaData,
         authenticationManager: AuthenticationManager,
         firebaseProvider: FirebaseProvider?) {
        self.appMetaData = appMetaData
        self.authenticationManager = authenticationManager
        self.firebaseProvider = firebaseProvider
        self.viewState = .loading
    }

    func fetchContent() async {
        await updateUser()
        viewState = .presentContent(using: setupSettingsDataModel())
    }

    private func setupSettingsDataModel() -> SettingsDataModel {
        SettingsDataModel(user: currentUser,
                          sections: [], 
                          logOut: setupSettingsLogOut(),
                          build: fetchAppBuildVersion())
    }

    private func setupSettingsLogOut() -> SettingsLogOutDataModel {
        SettingsLogOutDataModel(title: "Log out",
                                action: .alert(RDAlertModel(title: "Log out",
                                                            message: "Are you sure you would like to log out?", buttons: [
                                                                RDAlertButtonModel(title: "Cancel", action: {}, role: .cancel),
                                                                RDAlertButtonModel(title: "Log out", action: {
                                                                    Task {
                                                                        await self.logOut()
                                                                    }
                                                                }, role: .destructive)])))
    }

    private func setupSettingsSections() -> [SettingsSection] {
        [SettingsSection(header: "Header",
                         items: [
                            SettingsSectionItem(title: "pushNavigation", buttonAction: .pushNavigation(AnyView(ConstructionView()))),
                            SettingsSectionItem(title: "sheet", buttonAction: .sheet(AnyView(ConstructionView()))),
                            SettingsSectionItem(title: "action", buttonAction: .action { print("pressed") }),
                            SettingsSectionItem(title: "none")
                         ])
        ]
    }
    
    private func fetchAppBuildVersion() -> String? {
        if let appVersion = appMetaData.appVersion,
           let appBuild = appMetaData.appBuild {
            return "Build: \(appVersion) (\(appBuild))"
        } else {
            return nil
        }
    }

    private func updateUser() async {
        currentUser = await firebaseProvider?.fetchUser()
    }
}

extension SettingsProvider: LogoutProvidable {
    func logOut() async {
        await authenticationManager.logOut()
    }
}
