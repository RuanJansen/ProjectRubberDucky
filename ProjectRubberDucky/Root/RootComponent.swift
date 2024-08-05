import SwiftUI
import NeedleFoundation
import Combine

class RootComponent: BootstrapComponent {

    @State public var isAuthenticated = true
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

struct LaunchingView: View {
    @Binding var isLaunching: Bool
    @Environment(AppStyling.self) var appStyling

    var body: some View {
        VStack {
            appStyling.appIconImage
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 150)
            Text(appStyling.appName)
        }
        .font(.title)
        .foregroundStyle(appStyling.tintColor)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                isLaunching.toggle()
            }
        }
    }
}
