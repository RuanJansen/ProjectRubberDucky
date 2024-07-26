//
//  SearchUsecase.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/12.
//

import Foundation
import SwiftUI
import Combine

class SearchUsecase: ObservableObject {
    @Published var searchText: String
    @Published var searchActionHit: Bool

    init() {
        self.searchText = String()
        self.searchActionHit = false
    }

    public func search() {
        searchActionHit.toggle()
    }
}
