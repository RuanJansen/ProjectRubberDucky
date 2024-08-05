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

    init(appMetaData: AppMetaData) {
        self.appMetaData = appMetaData
        self.viewState = .loading
    }

    func fetchContent() async {
        viewState = .presentContent(using: setupSettingsDataModel())
    }

    private func setupSettingsDataModel() -> SettingsDataModel {
        SettingsDataModel(sections: setupSettingsSections(),
                          build: fetchAppBuildVersion())
    }

    private func setupSettingsSections() -> [SettingsSection] {
        [SettingsSection(header: "Header",
                         items: [
                            SettingsSectionItem(title: "something", buttonAction: .pushNavigation(AnyView(ConstructionView()))),
                            SettingsSectionItem(title: "something", buttonAction: .pushNavigation(AnyView(ConstructionView()))),
                            SettingsSectionItem(title: "something", buttonAction: .pushNavigation(AnyView(ConstructionView())))
                         ])
        ]
    }
    
    private func fetchAppBuildVersion() -> String {
        "Build: \(appMetaData.appVersion) \(appMetaData.appBuild)"
    }
}

