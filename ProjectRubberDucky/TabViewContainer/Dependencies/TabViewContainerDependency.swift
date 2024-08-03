import NeedleFoundation

protocol TabViewContainerDependency: Dependency {
    var videoPlayerComponent: VideoPlayerComponent { get }
    var homeComponent: HomeComponent { get }
}
