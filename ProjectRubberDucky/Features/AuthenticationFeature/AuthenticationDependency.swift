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

    public var authenticationMediator: AuthenticationMediator {
        shared {
            AuthenticationMediator(authenticateUserManager: authenticateUserManager,
                                   logoutUserManager: logoutUserManager,
                                   deleteUserManager: deleteUserManager)
        }
    }

    public var authenticateUserManager: AuthenticateUserManager {
        shared {
            AuthenticateUserManager(firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                                  firestoreUserFactory: firebaseComponent.firestoreUserFactory)
        }
    }

    public var logoutUserManager: LogOutUserManager {
        shared {
            LogOutUserManager(firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                              firestoreUserFactory: firebaseComponent.firestoreUserFactory)
        }
    }

    public var deleteUserManager: DeleteUserManager {
        shared {
            DeleteUserManager(firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
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
        ConcreteAppleSignInManager(authenticateUserManager: authenticateUserManager,
                           firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager)
    }

    public var emailSignInManager: EmailSignInManager {
        ConcreteEmailSignInManager(authenticateUserManager: authenticateUserManager,
                           firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                           firestoreUserFactory: firebaseComponent.firestoreUserFactory)
    }

    public var emailRegistrationManager: EmailRegistrationManager {
        ConcreteEmailRegistrationManager(authenticateUserManager: authenticateUserManager,
                                         deleteUserManager: deleteUserManager,
                                         firebaseAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                                         firestoreUserFactory: firebaseComponent.firestoreUserFactory)
    }

}
