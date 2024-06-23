//
//  VideoRepository.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/23.
//

import Foundation

class VideoRepository {
    func fetchRemoteData() async -> [VideoPlayerDataModel]? {
        do {
            guard let mockFilms = try await MockFilmCaller().fetchCodableDataModel() else { return nil }

            let dataModel = mockFilms.map {
                VideoPlayerDataModel(id: UUID(),
                                     title: $0.title,
                                     description: $0.description,
                                     url: URL(string: $0.videoURL)!,
                                     thumbnail: URL(string: $0.thumbnailURL)!)

            }
            return dataModel
        } catch {
            return nil
        }
    }
}

class MockFilmCaller {
    func fetchCodableDataModel() async throws -> [MockFilmsCodableModel]? {

        let type = [MockFilmsCodableModel].self
        let fileName = "MockFilms"

        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data(contentsOf: url)
            let result = try await DataDecoder.decode(data, to: type)
            return result
        } else {
            return nil
        }
    }
}
