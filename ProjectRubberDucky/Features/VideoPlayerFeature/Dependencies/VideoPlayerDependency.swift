import NeedleFoundation

protocol VideoPlayerDependency: Dependency {
    var videoPlayerFeatureProvider: any FeatureProvider { get }
}
