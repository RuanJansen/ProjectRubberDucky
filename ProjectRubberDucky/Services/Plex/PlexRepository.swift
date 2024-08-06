//
//  PlexRepository.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/30.
//

import Foundation
//import PlexKit

class PlexRepository {
    let plexContent: PlexContentFetchable

    init(plexContent: PlexContentFetchable) {
        self.plexContent = plexContent
    }

    func fetch(key: String) async -> [VideoDataModel]? {
        []
    }

//    func fetch(key: String) async -> [VideoDataModel]? {
//        var dataModel: [VideoDataModel] = []
////        plexContent.fetchLibraries { libraries in
//            guard let moviesLibrary = self.plexContent.fetch(.movie, for: key) else { return nil }
//            dump(moviesLibrary)
//            for movie in moviesLibrary.mediaContainer.directory {
//                if let ratingKey = movie.ratingKey,
//                let addedAt = movie.addedAt{
//                    guard let fileUrl = URL(string: "\(RuanMacbookAir.remote.rawValue)/library/parts/\(ratingKey)/\(addedAt)/file.mp4") else { continue }
//                    guard let thumbUrl =  URL(string: "\(RuanMacbookAir.remote.rawValue)/library/metadata/\(ratingKey)/thumb/\(addedAt)") else { continue }
//                    let title = movie.title
//                    let description = movie.summary
//                    let newModel = VideoDataModel(id: UUID(),
//                                         title: title,
//                                         description: description,
//                                         url: fileUrl,
//                                         thumbnail: thumbUrl)
//                    dataModel.append(newModel)
//                }
//            }
////        }
//        return dataModel
//    }
}
