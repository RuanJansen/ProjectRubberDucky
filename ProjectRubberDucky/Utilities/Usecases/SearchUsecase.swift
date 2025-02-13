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
    private let repository: PexelRepository?

    var searchText: String
    var searchVideos: [VideoDataModel]?
    var resultsFetched: Bool = false

    init(repository: PexelRepository? = nil) {
        self.repository = repository
        self.searchText = String()
    }

    public func search() async {
        self.searchVideos = await fetchVideos(using: searchText)
    }

    public func clearSearch() async {
        if searchText.isEmpty {
            self.resultsFetched = false
            self.searchVideos = nil
        }
    }

    private func fetchVideos(using prompt: String) async -> [VideoDataModel]? {
        resultsFetched = false
        if let repository = self.repository {
            if let fetchedContent = await repository.fetchRemoteData(prompt: prompt) {
                resultsFetched = true
                return fetchedContent
            }
        }
        resultsFetched = true
        return nil
    }
}
