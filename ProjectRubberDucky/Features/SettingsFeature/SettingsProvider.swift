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

    private let contentProvider: SettingsContentProvidable
    private var appMetaData: AppMetaData
    private var logoutManager: LogoutManageable
    private let firebaseProvider: UserAuthenticationProvideable?
    private let accountView: any FeatureView
    private var currentUser: UserServiceDataModel?

    init(contentProvider: SettingsContentProvidable,
         appMetaData: AppMetaData,
         logoutManager: LogoutManageable,
         firebaseProvider: UserAuthenticationProvideable?,
         accountView: any FeatureView) {
        self.contentProvider = contentProvider
        self.appMetaData = appMetaData
        self.logoutManager = logoutManager
        self.firebaseProvider = firebaseProvider
        self.accountView = accountView
        self.viewState = .loading
    }

    func fetchContent() async {
        await updateUser()
        let dataModel = await setupSettingsDataModel()

        await MainActor.run {
            viewState = .presenting(using: dataModel)
        }
    }

    private func setupSettingsDataModel() async -> SettingsDataModel {
        await SettingsDataModel(pageTitle: contentProvider.fetchPageTitle(), account: setupSettingsAccount(),
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

    private func setupSettingsSections() async -> [SectionDataModel] {
        let logoutSection = await setupLogoutSection()

        return [SectionDataModel(footer: fetchAppBuildVersion(),
                                 items: [
                                    logoutSection
                                 ])
        ]
    }

    private func setupLogoutSection() async -> SectionItemDataModel {
        let alertTitle = await contentProvider.fetchLogoutAlertTitle()
        let alertMessage = await contentProvider.fetchLogoutAlertMessage()
        let primaryActionText = await contentProvider.fetchLogoutAlertPrimaryActionText()
        let secondaryActionText = await contentProvider.fetchLogoutAlertSecondaryActionText()

        return SectionItemDataModel(title: alertTitle,
                                     buttonAction: .alert({RDAlertModel(title: alertTitle,
                                                                        message: alertMessage, buttons: [
                                                                          RDAlertButtonModel(title: primaryActionText, action: {}, role: .cancel),
                                                                          RDAlertButtonModel(title: secondaryActionText, action: {
                                                                              Task {
                                                                                  await self.logOut()
                                                                              }
                                                                          }, role: .destructive)])}),
                                     fontColor: .red,
                                     hasMaxWidth: true)
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
        await logoutManager.logOut()
    }
}
