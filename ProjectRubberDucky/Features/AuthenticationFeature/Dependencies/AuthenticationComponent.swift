import NeedleFoundation
import SwiftUI

extension RootComponent {
    public var authenticationComponent: AuthenticationComponent {
        AuthenticationComponent(parent: self)
    }

    public var authenticationFeatureProvider: any FeatureProvider {
        AuthenticationProvider()
    }

    public var authenticationManager: AuthenticationManager {
        AuthenticationManager(isAuthenticated: isAuthenticated)
    }

    public var authenticationUsecase: AuthenticationUsecase {
        AuthenticationUsecase(authenticationManager: authenticationManager)
    }
}

class AuthenticationComponent: Component<AuthenticationDependency> {
    public var feature: Feature {
        AuthenticationFeature(featureProvider: featureProvider,
                              authenticationUsecase: dependency.authenticationUsecase)
    }

    public var featureProvider: any FeatureProvider {
        dependency.authenticationFeatureProvider
    }
}
