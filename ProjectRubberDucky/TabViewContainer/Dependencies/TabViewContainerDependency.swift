import NeedleFoundation

protocol TabViewContainerDependency: Dependency {
    var homeComponent: HomeComponent { get }
    var subscribedComponent: SubscribedComponent { get }
    var libraryComponent: LibraryComponent { get }
    var settingsComponent: SettingsComponent { get }
    var tabFeatureFlagProvider: TabFeatureFlagProvidable { get }
}
