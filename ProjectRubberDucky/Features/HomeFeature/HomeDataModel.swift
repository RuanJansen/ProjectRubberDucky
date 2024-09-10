//
//  HomeDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/02.
//

import SwiftUI

struct HomeDataModel: Identifiable {
    let id: UUID
    let pageTitle: String
    let featuredVideos: [VideoDataModel]?
    let carousels: [CarouselDataModel]?

    init(pageTitle: String,
         topCarousel: [VideoDataModel]?,
         carousels: [CarouselDataModel]? = nil ) {
        self.id = UUID()
        self.pageTitle = pageTitle
        self.featuredVideos = topCarousel
        self.carousels = carousels
    }
}

struct CarouselDataModel: Identifiable {
    let id: UUID
    let title: String
    let videos: [VideoDataModel]
    let style: CarouselStyle

    var aspectRatio: CGSize {
        switch style {
        case .thumbnail:
            return CGSize(width: 1280, height: 720)
        case .poster:
            return CGSize(width: 27, height: 40)
        case .square:
            return CGSize(width: 1, height: 1)
        }
    }

    init(title: String, videos: [VideoDataModel], style: CarouselStyle) {
        self.id = UUID()
        self.title = title
        self.videos = videos
        self.style = style
    }
}

enum CarouselStyle {
    case thumbnail
    case poster
    case square
}
