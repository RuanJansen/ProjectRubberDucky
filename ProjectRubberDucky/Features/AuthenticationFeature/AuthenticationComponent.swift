import NeedleFoundation
import SwiftUI

extension RootComponent {
    public var authenticationComponent: AuthenticationComponent {
        AuthenticationComponent(parent: self)
    }

    public var authenticationFeatureProvider: any FeatureProvider {
        shared {
            AuthenticationProvider()
        }
    }

    public var authenticationManager: AuthenticationManager {
        shared {
            AuthenticationManager(firebaseAuthenticationManager: firebaseAuthenticationManager)
        }
    }

    public var firebaseAuthenticationManager: FirebaseAuthenticationManager {
        shared {
            FirebaseAuthenticationManager()
        }
    }

    public var authenticationUsecase: AuthenticationUsecase {
        shared {
            AuthenticationUsecase(authenticationManager: authenticationManager)
        }
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
