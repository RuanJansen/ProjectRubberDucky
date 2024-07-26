import Foundation
import NeedleFoundation

extension RootComponent {
    public var videoPlayerComponent: VideoPlayerComponent {
        VideoPlayerComponent(parent: self)
    }

    public var videoPlayerFeatureProvider: any FeatureProvider {
        VideoPlayerProvider(repository: plexComponent.plexRepository,
                            searchUsecase: searchUsecase)
    }

    public var videoRepository: PexelRepository {
        PexelRepository()
    }

    public var searchUsecase: SearchUsecase {
        SearchUsecase()
    }
}

class VideoPlayerComponent: Component<VideoPlayerDependency> {
    public var feature: Feature {
        VideoPlayerFeature(featureProvider: featureProvider, searchUsecase: searchUsecase)
    }

    public var featureProvider: any FeatureProvider {
        dependency.videoPlayerFeatureProvider
    }

    public var searchUsecase: SearchUsecase {
        dependency.searchUsecase
    }
}

