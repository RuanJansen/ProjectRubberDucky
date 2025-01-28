//
//  SearchProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/09/10.
//

import Foundation
import Observation

@Observable
class SearchProvider: FeatureProvider {
    typealias DataModel = SearchDataModel

    var viewState: ViewState<SearchDataModel>

    init() {
        self.viewState = .loading
    }

    func fetchContent() async {
        await setupSearchDataModel()
    }

    private func setupSearchDataModel() async {
        let dataModel = SearchDataModel(pageTitle: "Search")

        await MainActor.run {
            self.viewState = .presenting(using: dataModel)
        }
    }
}


