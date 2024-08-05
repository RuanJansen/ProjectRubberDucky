import Foundation
import NeedleFoundation

extension RootComponent {
    public var tabViewContainerComponent: TabViewContainerComponent {
        TabViewContainerComponent(parent: self)
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
        return [
            homeTab,
            subscribedTab
        ]
    }

    private var videoPlayerTab: any Tabable {
        TabViewContainerDataModel(name: "Video Player",
                                  systemImage: "video.fill",
                                  feature: dependency.videoPlayerComponent.feature)
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
}
