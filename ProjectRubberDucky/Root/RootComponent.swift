import SwiftUI
import NeedleFoundation
import Combine

class RootComponent: BootstrapComponent {
    @State public var appStyling: AppStyling
    @State public var appMetaData: AppMetaData
    
//    @Environment(Coordinator<MainCoordinatorViews>.self) private var navigationCoordinator
        
    override init() {
        self.appStyling = AppStyling()
        self.appMetaData = AppMetaData()
        super.init()
    }

    public var view: some View {
        RootView(mainFeature: tabViewContainerComponent.feature)
    }
    
    public var coordinatorStack: some View {
        shared {
            CoordinatorStack(root: MainCoordinatorDestination.root,
                             coordinator: navigationCoordinator)
                .environment(AppStyling())
                .environment(self.appMetaData)
                .onAppear() {
                    self.navigationManager.addListeners()
                }
        }
    }
    
    public var navigationCoordinator: Coordinator<MainCoordinatorDestination> {
        shared {
            Coordinator<MainCoordinatorDestination>()
        }
    }

    public var navigationManager: NavigationManager {
        return shared {
            NavigationManager(navigationCoordinator: navigationCoordinator,
                              onboardingFeature: onboardingComponent.feature,
                              authenticationFeature: authenticationComponent.feature,
                              userAuthenticationManager: userAuthenticationManager,
                              userDefaultsManager: userDefaultsManager)
        }
    }

    public var featureFlagProvider: FeatureFlagProvider {
        FeatureFlagProvider(featureFlagFetcher: featureFlagFetcher)
    }

    public var contentFetcher: ContentFetcher {
        shared {
            ContentFetcher(firebaseContentFetcher: firebaseComponent.firebaseRemoteConfig)
        }
    }
    
    public var featureFlagFetcher: FeatureFlagFetcher {
        FeatureFlagFetcher(firebaseFeatureFlagFetcher: firebaseComponent.firebaseRemoteConfig)
    }
    
    public var userDefaultsManager: UserDefaultsManager {
        shared {
            UserDefaultsManager()
        }
    }
}

