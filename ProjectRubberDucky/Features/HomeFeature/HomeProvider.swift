//
//  HomeProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/02.
//

import Observation
import Combine

@Observable
class HomeProvider: FeatureProvider {
    typealias DataModel = HomeDataModel

    var viewState: ViewState<HomeDataModel>

    private let repository: PexelRepository?

    init(repository: PexelRepository? = nil) {
        self.repository = repository
        self.viewState = .loading
    }

    func fetchContent() async {
        await setupHomeDataModel()
    }

    actor CarouselManager {
        var carousels: [CarouselDataModel] = []

        func addCarousel(_ carousel: CarouselDataModel) {
            carousels.append(carousel)
        }

        func getCarousels() -> [CarouselDataModel] {
            return carousels
        }
    }

    private func setupHomeDataModel() async {
        let carousels = await fetchDefaultVideoCarousels()

        await MainActor.run {
            self.viewState = .presentContent(using: HomeDataModel(carousels: carousels))
        }
    }

    private func fetchDefaultVideoCarousels() async -> [CarouselDataModel] {
        let prompts: [String] = ["Ocean", "Galaxy", "Mountains", "Nature", "Africa wild life", "Ocean wild life", "Insect wild life"]
        let carouselManager = CarouselManager()

        await withTaskGroup(of: Void.self) { taskGroup in
            for prompt in prompts {
                taskGroup.addTask {
                    var videos: [VideoDataModel] = []

                    if let repository = self.repository {
                        if let fetchedContent = await repository.fetchRemoteData(prompt: prompt) {
                            videos.append(contentsOf: fetchedContent)
                        } else {

                        }
                    }

                    let carousel = CarouselDataModel(title: prompt, videos: videos.sorted(by: { $0.title < $1.title }))
                    await carouselManager.addCarousel(carousel)
                }
            }
        }

        let carousels = await carouselManager.getCarousels().sorted(by: {$0.title < $1.title})

        return carousels
    }
}

extension HomeProvider: SearchableProvider {
    func clearSearch() async {
        await setupHomeDataModel()
    }
    
    func searchContent(prompt: String) async {
        let defaultCarousels = await fetchDefaultVideoCarousels()
        let searchVideos = await fetchSearchVideoCarousel(prompt: prompt)
        
        await MainActor.run {
            self.viewState = .presentContent(using: HomeDataModel(searchResults: searchVideos, carousels: defaultCarousels))
        }
    }

    private func fetchSearchVideoCarousel(prompt: String) async -> [VideoDataModel] {
        let videoManager = VideoManager()

        if let repository = self.repository {
            if let fetchedContent = await repository.fetchRemoteData(prompt: prompt) {
                await videoManager.addVideos(fetchedContent)
            }
        }

        let videos = await videoManager.getVideos()

        return videos
    }

    actor VideoManager {
        var videos: [VideoDataModel] = []

        func addVideos(_ newVideos: [VideoDataModel]) {
            videos.append(contentsOf: newVideos)
        }

        func getVideos() -> [VideoDataModel] {
            return videos
        }
    }
}
