import SwiftUI
import NeedleFoundation
import Combine

class RootComponent: BootstrapComponent {
//    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    @State public var appStyling: AppStyling
    @State public var appMetaData: AppMetaData

    override init() {
        self.appStyling = AppStyling()
        self.appMetaData = AppMetaData()
        super.init()
    }

    public var navigationManager: NavigationManager {
        print("RootComponent/navigationManager - authenticationManager.id:\(self.authenticationManager.id)")
        return shared {
            NavigationManager(mainFeature: tabViewContainerComponent.feature,
                              onboardingFeature: onboardingComponent.feature,
                              authenticationFeature: authenticationComponent.feature,
                              authenticationManager: self.authenticationManager,
                              onboardingUsecase: onboardingUsecase)
        }
    }

    public var view: some View {
        RootView(navigationManager: navigationManager)
            .environment(appStyling)
            .environment(self.appMetaData)
    }
}
