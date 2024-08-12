//
//  HomeDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/02.
//

import Foundation

struct HomeDataModel: Identifiable {
    let id: UUID
    let pageTitle: String
    let searchResults: [VideoDataModel]?
    let topCarousel: [VideoDataModel]?
    let carousels: [CarouselDataModel]?

    init(pageTitle: String,
         searchResults: [VideoDataModel]? = nil,
         topCarousel: [VideoDataModel]?,
         carousels: [CarouselDataModel]? = nil ) {
        self.id = UUID()
        self.pageTitle = pageTitle
        self.searchResults = searchResults
        self.topCarousel = topCarousel
        self.carousels = carousels
    }
}

struct CarouselDataModel: Identifiable {
    let id: UUID
    let title: String
    let videos: [VideoDataModel]

    init(title: String, videos: [VideoDataModel]) {
        self.id = UUID()
        self.title = title
        self.videos = videos
    }
}
