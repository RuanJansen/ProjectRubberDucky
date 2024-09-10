//
//  SearchDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/09/10.
//

import Foundation

struct SearchDataModel: Identifiable {
    let id: UUID
    let pageTitle: String

    init(pageTitle: String) {
        self.id = UUID()
        self.pageTitle = pageTitle
    }
}
