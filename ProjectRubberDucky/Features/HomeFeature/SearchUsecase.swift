//
//  SearchUsecase.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/12.
//

import Foundation
import SwiftUI
import Observation

@Observable
class SearchUsecase {
    var searchText: String
    private var provider: SearchProvidable

    init(provider: SearchProvidable) {
        self.provider = provider
        self.searchText = String()
    }

    public func search() async {
        await provider.searchContent(prompt: searchText)
    }

    public func clearSearch() async {
        if searchText.isEmpty {
            await provider.clearSearch()
        }
    }
}
