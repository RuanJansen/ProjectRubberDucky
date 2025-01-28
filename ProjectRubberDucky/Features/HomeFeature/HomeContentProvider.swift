//
//  HomeContentProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/11.
//

import Foundation

protocol HomeContentProvidable {
    func fetchPageTitle() async -> String
    func fetchVideoTitles() async -> [String]
}

class HomeContentProvider: HomeContentProvidable {
    var contentFetcher: ContentFetcher

    init(contentFetcher: ContentFetcher) {
        self.contentFetcher = contentFetcher
    }

    func fetchPageTitle() async -> String {
        await fetch(content: "pageTitle", for: "homeContent") ?? "-"
    }

    func fetchVideoTitles() async -> [String] {
        await fetchAll(from: "featuredVideoContent") ?? []
    }
}

extension HomeContentProvider: ContentProvidable {
    func fetchAll(from table: String) async -> [String]? {
        do {
            return try await contentFetcher.fetchAll(from: table)
        } catch {
            return nil
        }
    }
    
    func fetch(content id: String, for table: String) async -> String? {
        do {
            return try await contentFetcher.fetch(content: id, from: table)
        } catch {
            return nil
        }
    }
}
