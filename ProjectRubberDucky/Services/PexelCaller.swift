//
//  PexelCaller.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/24.
//

import Foundation

class PexelCaller {
    func fetchCodableDataModel() async throws -> [Video]? {
        let searchQuery = "nature"
        let domain = "https://api.pexels.com/"
        let path = "videos/search?query=\(searchQuery)&per_page=10&orientation=landscape"
        let key = "MpDL9W0pRkqO2xmRSVO3Nt9WiH7Zvp0Jbzl7cStQ9dprUe1BRsjhjktq"
        let type = PexelCodableModel.self
        let result = await ServiceFetcher.fetch(type, using: domain, form: path, where: key)
        return result?.videos
    }

    func fetchLocalCodableDataModel() async throws -> [Video]? {
        let type = PexelCodableModel.self
        let fileName = "PexelContent"
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data(contentsOf: url)
            let result = try await DataDecoder.decode(data, to: type)
            return result.videos
        } else {
            return nil
        }
    }
}
