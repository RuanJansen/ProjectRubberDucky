//
//  SettingsFeatureProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import Observation

@Observable
class SettingsProvider: FeatureProvider {
    typealias DataModel = SettingsDataModel

    var viewState: ViewState<SettingsDataModel>

    init() {
        self.viewState = .loading
    }

    func fetchContent() async {
        viewState = .none
    }
}

