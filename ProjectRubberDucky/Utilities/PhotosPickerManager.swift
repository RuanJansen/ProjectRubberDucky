//
//  PhotosPickerUsecase.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/10.
//

import SwiftUI
import PhotosUI

class PhotosPickerManager: ObservableObject {
    @Published var selection: PhotosPickerItem?

    init() {
        self.selection = nil
    }

    public func fetchImageData() async throws -> Data? {
        if let selection,
           let data = try await selection.loadTransferable(type: Data.self) {
            return data
        } else {
            return nil
        }
    }
}
