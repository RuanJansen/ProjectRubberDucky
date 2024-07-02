import NeedleFoundation

class VideoPlayerFeature<Provider>: Feature where Provider: VideoPlayerProvider {
    var featureProvider: any FeatureProvider

    init(featureProvider: any FeatureProvider) {
        self.featureProvider = featureProvider
    }

    public var featureView: any FeatureView {
        VideoPlayerView(provider: featureProvider as! Provider)
    }
}
