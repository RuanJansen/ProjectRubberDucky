import NeedleFoundation

protocol TabViewContainerDependency: Dependency {
    var videoPlayerComponent: VideoPlayerComponent { get }
    var homeComponent: HomeComponent { get }
    var subscribedComponent: SubscribedComponent { get }
    var libraryComponent: LibraryComponent { get }
    var settingsComponent: SettingsComponent { get }
    var searchComponent: SearchComponent { get }
    var tabFeatureFlagProvider: TabFeatureFlagProvidable { get }
}

extension RootComponent {
    public var tabViewContainerComponent: TabViewContainerComponent {
        TabViewContainerComponent(parent: self)
    }

    public var tabFeatureFlagProvider: TabFeatureFlagProvidable {
        featureFlagProvider as! TabFeatureFlagProvidable
    }
}
