import SwiftUI
import NeedleFoundation
import Combine

class RootComponent: BootstrapComponent {
    @State public var appStyling: AppStyling
    @State public var appMetaData: AppMetaData

    override init() {
        self.appStyling = AppStyling()
        self.appMetaData = AppMetaData()
        super.init()
    }

    public var view: some View {
        RootView(navigationManager: navigationManager)
            .environment(appStyling)
            .environment(self.appMetaData)
    }

    public var navigationManager: NavigationManager {
        return shared {
            NavigationManager(mainFeature: tabViewContainerComponent.feature,
                              onboardingFeature: onboardingComponent.feature,
                              authenticationFeature: authenticationComponent.feature,
                              authenticationManager: self.authenticationManager,
                              userDefaultsManager: userDefaultsManager)
        }
    }

    public var firebaseRemoteConfig: FirebaseRemoteConfig {
        shared {
            FirebaseRemoteConfig()
        }
    }

    public var contentFetcher: ContentFetcher {
        shared {
            ContentFetcher(firebaseContentFetcher: firebaseRemoteConfig)
        }
    }

    public var userDefaultsManager: UserDefaultsManager {
        shared {
            UserDefaultsManager()
        }
    }
}
