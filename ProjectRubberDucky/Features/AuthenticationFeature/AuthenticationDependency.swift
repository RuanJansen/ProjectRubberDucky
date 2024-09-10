import NeedleFoundation

protocol AuthenticationDependency: Dependency {
    var authenticationFeatureProvider: any FeatureProvider { get }
    var authenticationUsecase: AuthenticationUsecase { get }
}

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
        ConcreteAppleSignInManager(authenticationManager: authenticationManager,
                           firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager)
    }

    public var emailSignInManager: EmailSignInManager {
        ConcreteEmailSignInManager(authenticationManager: authenticationManager,
                           firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                           firestoreUserFactory: firebaseComponent.firestoreUserFactory)
    }

    public var emailRegistrationManager: EmailRegistrationManager {
        ConcreteEmailRegistrationManager(authenticationManager: authenticationManager,
                                 firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                                 firestoreUserFactory: firebaseComponent.firestoreUserFactory)
    }

}
