//
//  SettingsFeatureProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import Observation
import SwiftUI
import Kingfisher

@Observable
class SettingsProvider: FeatureProvider {
    typealias DataModel = SettingsDataModel

    var viewState: ViewState<SettingsDataModel>

    private var appMetaData: AppMetaData
    private var authenticationManager: AuthenticationManager
    private let firebaseProvider: FirebaseProvider?
    private let accountView: any FeatureView
    private var currentUser: UserDataModel?

    init(appMetaData: AppMetaData,
         authenticationManager: AuthenticationManager,
         firebaseProvider: FirebaseProvider?,
         accountView: any FeatureView) {
        self.appMetaData = appMetaData
        self.authenticationManager = authenticationManager
        self.firebaseProvider = firebaseProvider
        self.accountView = accountView
        self.viewState = .loading
    }

    func fetchContent() async {
        await updateUser()
        viewState = .presentContent(using: setupSettingsDataModel())
    }

    private func setupSettingsDataModel() -> SettingsDataModel {
        SettingsDataModel(account: setupSettingsAccount(),
                          sections: [],
                          logOut: setupSettingsLogOut(),
                          build: fetchAppBuildVersion())
    }

    private func setupSettingsAccount() -> SettingsAccountDataModel? {
        guard let user = currentUser else {
            return nil
        }

        return SettingsAccountDataModel(imageURL: user.photoURL,
                                        title: (user.displayName ?? user.email) ?? "User",
                                        action: .navigatate(AnyView(accountView), hideCevron: false))
    }

    private func setupSettingsLogOut() -> LogOutDataModel {
        LogOutDataModel(title: "Log out",
                                action: .alert(RDAlertModel(title: "Log out",
                                                            message: "Are you sure you would like to log out?", buttons: [
                                                                RDAlertButtonModel(title: "Cancel", action: {}, role: .cancel),
                                                                RDAlertButtonModel(title: "Log out", action: {
                                                                    Task {
                                                                        await self.logOut()
                                                                    }
                                                                }, role: .destructive)])))
    }

    private func setupSettingsSections() -> [SectionDataModel] {
        [SectionDataModel(header: "Header",
                         items: [
                            SectionItemDataModel(title: "pushNavigation", buttonAction: .navigatate(AnyView(ConstructionView()))),
                            SectionItemDataModel(title: "sheet", buttonAction: .sheet(AnyView(ConstructionView()))),
                            SectionItemDataModel(title: "action", buttonAction: .action { print("pressed") }),
                            SectionItemDataModel(title: "none", buttonAction: .none)
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
