//
//  PlexRepository.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/30.
//

import Foundation
import PlexKit

class PlexRepository {
    let plexCaller: PlexGateway

    init(plexCaller: PlexGateway) {
        self.plexCaller = plexCaller
    }

    func fetchTest() async {
        plexCaller.fetchMovies(for: PlexAuthentication.ruan.username, and: PlexAuthentication.ruan.password)
    }

    func fetch() async {
        plexCaller.fetchLibraries { libraries in
            guard let libraryKey = libraries?.first?.key else { return }
            let moviesLibrary = self.plexCaller.fetch(.movie, for: libraryKey)
            dump(moviesLibrary)
        }
    }
}

struct PlexContainer {
    public let art: String?
    public let content: String?
    public let thumb: String?
    public let title1: String?

    init(art: String?, content: String?, thumb: String?, title1: String?) {
        self.art = art
        self.content = content
        self.thumb = thumb
        self.title1 = title1
    }
}
