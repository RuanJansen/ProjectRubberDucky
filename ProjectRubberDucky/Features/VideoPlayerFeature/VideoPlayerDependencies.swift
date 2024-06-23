import Foundation

protocol VideoPlayerDependency {
    var videoPlayerFeatureProvider: any FeatureProvider { get }
}
