//
//  PlexRepository.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/30.
//

import Foundation
import PlexKit

class PlexRepository {
    let plexContent: PlexContentFetchable

    init(plexContent: PlexContentFetchable) {
        self.plexContent = plexContent
    }

    func fetch(key: String) async -> [VideoPlayerDataModel]? {
        plexContent.fetchLibraries { libraries in
            let moviesLibrary = self.plexContent.fetch(.movie, for: key)
            dump(moviesLibrary)
        }
        return nil
    }
}
