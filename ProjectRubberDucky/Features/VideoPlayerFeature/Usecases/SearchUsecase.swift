//
//  SearchUsecase.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/12.
//

import Foundation
import SwiftUI
import Observation

@Observable
class SearchUsecase {
    var searchText: String
    var searchActionHit: Bool

    init() {
        self.searchText = String()
        self.searchActionHit = false
    }

    public func search() {
        searchActionHit.toggle()
    }
}
