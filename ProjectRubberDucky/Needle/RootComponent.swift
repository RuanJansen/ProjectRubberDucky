import SwiftUI
import NeedleFoundation
import Combine

@Observable
class ToolbarManager {
    var state: ToolbarState = .none

    func set(to state: ToolbarState) -> any ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Image(systemName: "person")
        }
    }
}

enum ToolbarState {
    case none
    case home
}

class RootComponent: BootstrapComponent {

    @State var isAuthenticated = true
    private var anyCancelables = Set<AnyCancellable>()

    @State public var onboardingUsecase: OnboardingUsecase = OnboardingUsecase()

    override init() {
        super.init()
        addSubscribers()
    }

    private func addSubscribers() {

        ///mimic authentication
        authenticationManager.$userIsAuthenticated.sink { result in
            self.isAuthenticated = result
        }
        .store(in: &anyCancelables)
    }

    public var view: some View {
        RootView(feature: isAuthenticated ? tabViewContainerComponent.feature : authenticationComponent.feature)
            .if(isAuthenticated) { rootView in
                rootView
                    .sheet(isPresented: onboardingUsecase.$isShowingOnboarding) {
                        AnyView(self.onboardingComponent.feature.featureView)
                    }
            }
            .environment(ToolbarManager())
    }
}

struct RootView: View {
    let feature: any Feature

    init(feature: any Feature) {
        self.feature = feature
    }

    var body: some View {
        AnyView(feature.featureView)
    }
}
