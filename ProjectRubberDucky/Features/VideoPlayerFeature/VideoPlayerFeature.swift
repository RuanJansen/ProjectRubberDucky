import NeedleFoundation

class VideoPlayerFeature<Provider>: Feature where Provider: VideoPlayerProvider {
    var featureProvider: any FeatureProvider
    var searchUsecase: SearchUsecase

    init(featureProvider: any FeatureProvider,
         searchUsecase: SearchUsecase) {
        self.featureProvider = featureProvider
        self.searchUsecase = searchUsecase
    }

    public var featureView: any FeatureView {
        VideoPlayerView(provider: featureProvider as! Provider, searchUsecase: searchUsecase)
    }
}
