//
//  VideoPlayerProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/23.
//

import Foundation

class VideoPlayerProvider: FeatureProvider {
    public typealias DataModel = [VideoPlayerDataModel]

    @Published public var viewState: ViewState<DataModel>

    let repository: VideoRepository

    init(repository: VideoRepository) {
        self.repository = repository
        self.viewState = .loading
    }

    public func fetchContent() async {
        if let fetchedDataModel = await repository.fetchRemoteData() {
            let dataModel = fetchedDataModel
            await MainActor.run {
                self.viewState = .presentContent(using: dataModel)
            }
        } else {
            await MainActor.run {
                self.viewState = .error
            }
        }
    }
}
