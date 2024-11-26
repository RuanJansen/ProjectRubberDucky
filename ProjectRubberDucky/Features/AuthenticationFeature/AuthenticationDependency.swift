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

    public var authenticationUsecase: AuthenticationUsecase {
        shared {
            AuthenticationUsecase(appleSignInManager: appleSignInManager,
                                  emailSignInManager: emailSignInManager,
                                  emailRegistrationManager: emailRegistrationManager)
        }
    }
    
    public var userAuthenticationManager: UserAuthenticationManageable {
        shared {
            UserAuthenticationManager(serviceAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                                      userDatabaseManager: firebaseComponent.userDatabaseManager)
        }
    }

    public var appleSignInManager: any AppleSignInManageable {
        AppleSignInManager(userAuthenticationManager: userAuthenticationManager,
                                   serviceAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                                   userDatabaseManager: firebaseComponent.userDatabaseManager)
    }

    public var emailSignInManager: EmailSignInManageable {
        EmailSignInManager(userAuthenticationManager: userAuthenticationManager, serviceAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                                   userDatabaseManager: firebaseComponent.userDatabaseManager)
    }

    public var emailRegistrationManager: EmailRegistrationManageable {
        EmailRegistrationManager(userAuthenticationManager: userAuthenticationManager,
                                         serviceAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                                         userDatabaseManager: firebaseComponent.userDatabaseManager)
    }
    
    public var userDeleteManager: UserDeleteManageable {
        UserDeleteManager(userAuthenticationManager: userAuthenticationManager,
                                  serviceAuthenticationManager: firebaseComponent.firebaseAuthenticationManager,
                                  userDatabaseManager: firebaseComponent.userDatabaseManager)
    }

    public var userLogoutManager: LogoutManageable {
        LogoutManager(userAuthenticationManager: userAuthenticationManager, authenticationManager: firebaseComponent.firebaseAuthenticationManager)
    }
}
