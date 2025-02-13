//
//  VideoRepository.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/23.
//

import Foundation

class PexelRepository {
    func fetchRemoteData(prompt: String? = nil) async -> [VideoDataModel]? {
        do {
            guard let pexelVideos = try await PexelGateway().fetchCodableDataModel(prompt: prompt) else { return nil }

            let pexelDataModel = pexelVideos.map {
                VideoDataModel(id: UUID(),
                               title: String(describing: $0.user.name),
                               genre: prompt,
                               quality: $0.videoFiles.first!.quality.rawValue,
                               videoFileUrl: URL(string: $0.videoFiles.first!.link)!,
                               thumbnailImageUrl: URL(string: $0.image)!)
            }

            return pexelDataModel
        } catch {
            return nil
        }
    }
}
