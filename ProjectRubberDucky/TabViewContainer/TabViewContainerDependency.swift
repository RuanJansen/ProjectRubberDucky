import NeedleFoundation

protocol TabViewContainerDependency: Dependency {
    var homeComponent: HomeComponent { get }
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
