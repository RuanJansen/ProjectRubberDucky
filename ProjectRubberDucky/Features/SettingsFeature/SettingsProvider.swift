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
    private var currentUser: UserAuthDataModel?

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
        await MainActor.run {
            viewState = .presentContent(using: setupSettingsDataModel())
        }
    }

    private func setupSettingsDataModel() -> SettingsDataModel {
        SettingsDataModel(account: setupSettingsAccount(),
                          sections: setupSettingsSections(),
                          build: fetchAppBuildVersion())
    }

    private func setupSettingsAccount() -> SettingsAccountDataModel? {
        guard let user = currentUser else {
            return nil
        }

        return SettingsAccountDataModel(imageURL: user.photoURL,
                                        title: (user.displayName ?? user.email) ?? "User",
                                        action: .navigate(hideChevron: false) {
            AnyView(self.accountView)
        })
    }

    private func setupSettingsSections() -> [SectionDataModel] {
        [SectionDataModel(footer: fetchAppBuildVersion(),
                          items: [SectionItemDataModel(title: "Log out",
                                                       buttonAction: .alert({RDAlertModel(title: "Log out",
                                                                                          message: "Are you sure you would like to log out?", buttons: [
                                                                                            RDAlertButtonModel(title: "Cancel", action: {}, role: .cancel),
                                                                                            RDAlertButtonModel(title: "Log out", action: {
                                                                                                Task {
                                                                                                    await self.logOut()
                                                                                                }
                                                                                            }, role: .destructive)])}),
                                                       fontColor: .red,
                                                       hasMaxWidth: true)])
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
