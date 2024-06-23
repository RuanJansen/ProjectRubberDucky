//
//  VideoPlayerDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/23.
//

import Foundation

struct VideoPlayerDataModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let url: URL
    let thumbnail: URL

    init(id: UUID, title: String, description: String, url: URL, thumbnail: URL) {
        self.id = id
        self.title = title
        self.description = description
        self.url = url
        self.thumbnail = thumbnail
    }
}
