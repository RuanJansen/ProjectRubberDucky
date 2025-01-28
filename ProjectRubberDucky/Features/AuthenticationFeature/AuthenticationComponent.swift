import NeedleFoundation
import SwiftUI

class AuthenticationComponent: Component<AuthenticationDependency> {
    public var feature: Feature {
        AuthenticationFeature(featureProvider: featureProvider,
                              authenticationUsecase: dependency.authenticationUsecase)
    }

    public var featureProvider: any FeatureProvider {
        dependency.authenticationFeatureProvider
    }
}
