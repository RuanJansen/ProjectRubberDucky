//
//  LibraryProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import Observation

@Observable
class LibraryProvider: FeatureProvider {
    typealias DataModel = LibraryDataModel

    var viewState: ViewState<LibraryDataModel>

    init() {
        self.viewState = .loading
    }

    func fetchContent() async {
        self.viewState = .none
    }

}

