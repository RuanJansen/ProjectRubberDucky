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
//            guard let mockFilms = try await MockFilmCaller().fetchCodableDataModel() else { return nil }
//
//            let mockDataModel = mockFilms.map {
//                VideoPlayerDataModel(id: UUID(),
//                                     title: $0.title,
//                                     description: $0.description,
//                                     url: URL(string: $0.videoURL)!,
//                                     thumbnail: URL(string: $0.thumbnailURL)!)
//
//            }

            guard let pexelVideos = try await PexelCaller().fetchCodableDataModel() else { return nil }

            let pexelDataModel = pexelVideos.map { 
                VideoPlayerDataModel(id: UUID(),
                                     title: String(describing: $0.user.name),
                                     url: URL(string: $0.videoFiles.first!.link)!,
                                     thumbnail: URL(string: $0.image)!,
                                     quality: $0.videoFiles.first!.quality.rawValue)
            }

            return pexelDataModel
        } catch {
            return nil
        }
    }
}
