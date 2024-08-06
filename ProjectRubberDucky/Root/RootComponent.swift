import SwiftUI
import NeedleFoundation
import Combine

class RootComponent: BootstrapComponent {
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    @State public var onboardingUsecase: OnboardingUsecase
    @State public var appStyling: AppStyling
    @State public var appMetaData: AppMetaData

    override init() {
        self.onboardingUsecase = OnboardingUsecase()
        self.appStyling = AppStyling()
        self.appMetaData = AppMetaData()
        super.init()
    }

    public var view: some View {
        RootView(feature: isAuthenticated ? tabViewContainerComponent.feature : authenticationComponent.feature)
            .environment(appStyling)
            .environment(self.appMetaData)
            .if(isAuthenticated) { rootView in
                rootView
                    .sheet(isPresented: onboardingUsecase.$isShowingOnboarding) {
                        AnyView(self.onboardingComponent.feature.featureView)
                            .environment(self.appStyling)
                    }
            }
    }
}
