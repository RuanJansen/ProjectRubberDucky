import NeedleFoundation

extension RootComponent {
    public var authenticationComponent: AuthenticationComponent {
        AuthenticationComponent(parent: self)
    }

    public var authenticationFeatureProvider: any FeatureProvider {
        AuthenticationProvider()
    }

    public var authenticationManager: AuthenticationManager {
        AuthenticationManager(plexAthenticator: plexGateway)
    }
}

class AuthenticationComponent: Component<AuthenticationDependency> {
    public var feature: Feature {
        AuthenticationFeature(featureProvider: featureProvider)
    }

    public var featureProvider: any FeatureProvider {
        dependency.authenticationFeatureProvider
    }
}
