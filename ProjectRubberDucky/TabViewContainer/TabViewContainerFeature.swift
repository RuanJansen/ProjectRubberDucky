import Foundation
import NeedleFoundation

class TabViewContainerFeature: Feature {
    var featureProvider: any FeatureProvider

    init(featureProvider: any FeatureProvider) {
        self.featureProvider = featureProvider
    }

    public var featureView: any FeatureView {
        TabViewContainerView(provider: featureProvider as! TabViewContainerProvider)
    }
}
