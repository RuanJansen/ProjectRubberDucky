import Foundation
import NeedleFoundation

extension RootComponent {
    public var tabViewContainerComponent: TabViewContainerComponent {
        TabViewContainerComponent(parent: self)
    }

    public var tabFeatureFlagProvider: TabFeatureFlagProvidable {
        featureFlagProvider as! TabFeatureFlagProvidable
    }
}

class TabViewContainerComponent: Component<TabViewContainerDependency> {
    public var feature: Feature {
        TabViewContainerFeature(featureProvider: featureProvider)
    }

    public var featureProvider: any FeatureProvider {
        TabViewContainerProvider(tabs: tabs)
    }

    private var tabs: [any Tabable]? {
        var tabs: [any Tabable] = []

        if homeTabFeatreFlag {
            tabs.append(homeTab)
        }

        if subscribedTabFeatreFlag {
            tabs.append(subscribedTab)
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

    public var subscribedTabFeatreFlag: Bool {
        tabFeatureFlagProvider.fetcSubscribedTabFeatreFlag()
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

    private var subscribedTab: any Tabable {
        TabViewContainerDataModel(name: "Subscribed",
                                  systemImage: "tv.badge.wifi",
                                  feature: dependency.subscribedComponent.feature)
    }

    private var libraryTab: any Tabable {
        TabViewContainerDataModel(name: "Library",
                                  systemImage: "books.vertical.fill",
                                  feature: dependency.libraryComponent.feature)
    }

    private var settingsTab: any Tabable {
        TabViewContainerDataModel(name: "Settings",
                                  systemImage: "gear",
                                  feature: dependency.settingsComponent.feature)
    }
}
