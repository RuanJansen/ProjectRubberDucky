//
//  HomeContentProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/11.
//

import Foundation

protocol HomeContentProvidable {
    func fetchPageTitle() async -> String
    func fetchCarousel1() async -> String
    func fetchCarousel2() async -> String
    func fetchCarousel3() async -> String
    func fetchCarousel4() async -> String
    func fetchCarousel5() async -> String
}

class HomeContentProvider: HomeContentProvidable {
    var contentFetcher: ContentFetcher

    init(contentFetcher: ContentFetcher) {
        self.contentFetcher = contentFetcher
    }

    func fetchPageTitle() async -> String {
        await fetch(content: "pageTitle", for: "homeContent") ?? "-"
    }

    func fetchCarousel1() async -> String {
        await fetch(content: "carousel1", for: "homeContent") ?? "-"
    }

    func fetchCarousel2() async -> String {
        await fetch(content: "carousel2", for: "homeContent") ?? "-"
    }

    func fetchCarousel3() async -> String {
        await fetch(content: "carousel3", for: "homeContent") ?? "-"
    }

    func fetchCarousel4() async -> String {
        await fetch(content: "carousel4", for: "homeContent") ?? "-"
    }

    func fetchCarousel5() async -> String {
        await fetch(content: "carousel5", for: "homeContent") ?? "-"
    }
}

extension HomeContentProvider: ContentProvidable {
    func fetch(content id: String, for table: String) async -> String? {
        do {
            return try await contentFetcher.fetch(content: id, for: table)
        } catch {
            return nil
        }
    }
}
