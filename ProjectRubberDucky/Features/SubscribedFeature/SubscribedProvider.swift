//
//  SubscribedProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import Observation

@Observable
class SubscribedProvider: FeatureProvider {
    typealias DataModel = SubscribedDataModel

    var viewState: ViewState<SubscribedDataModel>

    init() {
        self.viewState = .loading
    }

    func fetchContent() async {
        viewState = .none
    }
}
