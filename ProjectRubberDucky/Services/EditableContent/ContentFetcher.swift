//
//  ContentFetcher.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import Foundation

class ContentFetcher {
    static public func fetch(content id: String, for table: String) async throws -> String? {
        if let url = Bundle.main.url(forResource: table, withExtension: "json") {
            let data = try Data(contentsOf: url)
            let type = ManifestCodableModel.self
            let result = try await DataDecoder.decode(data, to: type)
            return result.content.filter { $0.id == id }.description
        } else {
            print("\(table)/\(id) not reachable")
            return nil
        }
    }
}
