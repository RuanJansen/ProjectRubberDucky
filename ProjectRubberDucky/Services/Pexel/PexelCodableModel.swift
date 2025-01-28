// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pexelCodableModel = try? JSONDecoder().decode(PexelCodableModel.self, from: jsonData)

import Foundation

// MARK: - PexelCodableModel
struct PexelCodableModel: Codable {
    let page, perPage: Int
    let videos: [Video]
    let totalResults: Int
    let nextPage, url: String

    enum CodingKeys: String, CodingKey {
        case page
        case perPage
        case videos
        case totalResults
        case nextPage
        case url
    }
}

// MARK: - Video
struct Video: Codable {
    let id, width, height, duration: Int
    let url: String
    let image: String
    let user: Creator
    let videoFiles: [VideoFile]
    let videoPictures: [VideoPicture]

    enum CodingKeys: String, CodingKey {
        case id, width, height, duration
        case url, image
        case user
        case videoFiles
        case videoPictures
    }
}

// MARK: - User
struct Creator: Codable {
    let id: Int
    let name: String
    let url: String
}

// MARK: - VideoFile
struct VideoFile: Codable {
    let id: Int
    let quality: Quality
    let fileType: FileType
    let width, height: Int
    let fps: Double
    let link: String
    let size: Int

    enum CodingKeys: String, CodingKey {
        case id, quality
        case fileType
        case width, height, fps, link, size
    }
}

enum FileType: String, Codable {
    case videoMp4 = "video/mp4"
}

enum Quality: String, Codable {
    case hd = "hd"
    case sd = "sd"
    case uhd = "uhd"
}

// MARK: - VideoPicture
struct VideoPicture: Codable {
    let id, nr: Int
    let picture: String
}
