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
