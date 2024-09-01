import NeedleFoundation
import SwiftUI

extension RootComponent {
    public var authenticationComponent: AuthenticationComponent {
        AuthenticationComponent(parent: self)
    }

    public var authenticationFeatureProvider: any FeatureProvider {
        shared {
            AuthenticationProvider(contentProvider: authenticationContentProvider)
        }
    }

    public var authenticationContentProvider: AuthenticationContentProvidable {
        AuthenticationContentProvider(contentFetcher: contentFetcher)
    }

    public var authenticationManager: AuthenticationManager {
        shared {
            AuthenticationManager(firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                                  firestoreUserFactory: firebaseComponent.firestoreUserFactory)
        }
    }

    public var authenticationUsecase: AuthenticationUsecase {
        shared {
            AuthenticationUsecase(appleSignInManager: appleSignInManager, 
                                  emailSignInManager: emailSignInManager,
                                  emailRegistrationManager: emailRegistrationManager)
        }
    }

    public var appleSignInManager: AppleSignInManager {
        AppleSignInManager(authenticationManager: authenticationManager, 
                           firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager)
    }

    public var emailSignInManager: EmailSignInManager {
        EmailSignInManager(authenticationManager: authenticationManager, 
                           firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                           firestoreUserFactory: firebaseComponent.firestoreUserFactory)
    }

    public var emailRegistrationManager: EmailRegistrationManager {
        EmailRegistrationManager(authenticationManager: authenticationManager, 
                                 firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                                 firestoreUserFactory: firebaseComponent.firestoreUserFactory)
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
