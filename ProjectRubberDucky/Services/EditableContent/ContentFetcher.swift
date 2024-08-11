//
//  ContentFetcher.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import Foundation

class ContentFetcher {
    let firebaseContentFetcher: ContentFetchable

    init(firebaseContentFetcher: ContentFetchable) {
        self.firebaseContentFetcher = firebaseContentFetcher
    }

    public func fetch(content id: String, for table: String) async throws -> String? {
        let data = firebaseContentFetcher.fetchContent(forKey: table)
        let type = ManifestCodableModel.self
        let result = try await DataDecoder.decode(data, to: type)

        return result.content.first(where: { $0.id == id })?.description
    }
}
