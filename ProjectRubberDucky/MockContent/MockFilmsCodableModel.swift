// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mockFilmsCodableModel = try? JSONDecoder().decode(MockFilmsCodableModel.self, from: jsonData)

import Foundation

// MARK: - MockFilmsCodableModelElement
struct MockFilmsCodableModel: Codable {
    let id, title: String
    let thumbnailURL: String
    let duration, uploadTime, views, author: String
    let videoURL: String
    let description, subscriber: String
    let isLive: Bool

    enum CodingKeys: String, CodingKey {
        case id, title
        case thumbnailURL = "thumbnailUrl"
        case duration, uploadTime, views, author
        case videoURL = "videoUrl"
        case description, subscriber, isLive
    }
}
