import Foundation
import NeedleFoundation

class TabViewContainerFeature: Feature {
    var featureProvider: any FeatureProvider
    var navigationCoordinator: Coordinator<MainCoordinatorDestination>

    init(featureProvider: any FeatureProvider,
         navigationCoordinator: Coordinator<MainCoordinatorDestination>) {
        self.featureProvider = featureProvider
        self.navigationCoordinator = navigationCoordinator
    }

    public var featureView: any FeatureView {
        TabViewContainerView(provider: featureProvider as! TabViewContainerProvider, navigationCoordinator: navigationCoordinator)
    }
}
