import Foundation
import NeedleFoundation

class TabViewContainerComponent: Component<TabViewContainerDependency> {
    public var feature: Feature {
        TabViewContainerFeature(featureProvider: featureProvider, navigationCoordinator: dependency.navigationCoordinator)
    }

    public var featureProvider: any FeatureProvider {
        TabViewContainerProvider(tabs: tabs)
    }

    private var tabs: [any Tabable]? {
        var tabs: [any Tabable] = []

        if homeTabFeatreFlag {
            tabs.append(homeTab)
        }

        if searchTabFeatreFlag {
            tabs.append(searchTab)
        }

        if libraryTabFeatreFlag {
            tabs.append(libraryTab)
        }

        if settingsTabFeatreFlag {
            tabs.append(settingsTab)
        }

        return tabs
    }

    private var tabFeatureFlagProvider: TabFeatureFlagProvidable {
        dependency.tabFeatureFlagProvider
    }

    public var homeTabFeatreFlag: Bool {
        tabFeatureFlagProvider.fetchHomeTabFeatreFlag()
    }

    public var searchTabFeatreFlag: Bool {
        tabFeatureFlagProvider.fetcSearchTabFeatreFlag()
    }

    public var libraryTabFeatreFlag: Bool {
        tabFeatureFlagProvider.fetchLibraryTabFeatreFlag()
    }

    public var settingsTabFeatreFlag: Bool {
        tabFeatureFlagProvider.fetchSettingsTabFeatreFlag()
    }

    private var homeTab: any Tabable {
        TabViewContainerDataModel(name: "Home",
                                  systemImage: "house.fill",
                                  feature: dependency.homeComponent.feature)
    }

    private var libraryTab: any Tabable {
        TabViewContainerDataModel(name: "Library",
                                  systemImage: "books.vertical.fill",
                                  feature: dependency.libraryComponent.feature)
    }

    private var searchTab: any Tabable {
        TabViewContainerDataModel(name: "Search",
                                  systemImage: "magnifyingglass",
                                  feature: dependency.searchComponent.feature)
    }

    private var settingsTab: any Tabable {
        TabViewContainerDataModel(name: "Settings",
                                  systemImage: "gear",
                                  feature: dependency.settingsComponent.feature)
    }
}
