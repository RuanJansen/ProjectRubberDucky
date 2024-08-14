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

    private let contentProvider: HomeContentProvidable
    private let repository: PexelRepository?

    init(contentProvider: HomeContentProvidable,
         repository: PexelRepository? = nil) {
        self.contentProvider = contentProvider
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
        let pageTitle = await contentProvider.fetchPageTitle()
        let carousels = await fetchDefaultVideoCarousels()
        let featuredVideos = await setupFeaturedVideos()

        await MainActor.run {
            self.viewState = .presentContent(using: HomeDataModel(pageTitle: pageTitle, topCarousel: featuredVideos, carousels: carousels))
        }
    }

    private func fetchDefaultVideoCarousels() async -> [CarouselDataModel] {
        var prompts: [String] = await contentProvider.fetchVideoTitles()

        let carouselManager = CarouselManager()

        await withTaskGroup(of: Void.self) { taskGroup in
            for prompt in prompts {
                taskGroup.addTask {
                    var videos: [VideoDataModel] = []

                    await videos.append(contentsOf: self.fetchVideos(using: prompt))

                    let carousel = CarouselDataModel(title: prompt, videos: videos.sorted(by: { $0.title < $1.title }))
                    await carouselManager.addCarousel(carousel)
                }
            }
        }

        let carousels = await carouselManager.getCarousels().sorted(by: {$0.title < $1.title})

        return carousels
    }

    private func fetchVideos(using prompt: String) async -> [VideoDataModel] {
        if let repository = self.repository {
            if let fetchedContent = await repository.fetchRemoteData(prompt: prompt) {
                return fetchedContent
            }
        }
        return []
    }

    private func setupFeaturedVideos() async -> [VideoDataModel] {
        var videos: [VideoDataModel] = []

        var prompts: [String] = await contentProvider.fetchVideoTitles()

        for prompt in prompts {
            if let randomVideo = await self.fetchVideos(using: prompt).randomElement() {
                videos.append(randomVideo)
            }
        }
        return videos
    }
}
