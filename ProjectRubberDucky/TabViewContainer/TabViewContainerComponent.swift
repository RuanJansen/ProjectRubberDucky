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
            videoPlayerTab
        ]
    }

    private var videoPlayerTab: any Tabable {
        TabViewContainerDataModel(name: "Video Player",
                                  systemImage: "video.fill",
                                  feature: dependency.videoPlayerComponent.feature)
    }
}
