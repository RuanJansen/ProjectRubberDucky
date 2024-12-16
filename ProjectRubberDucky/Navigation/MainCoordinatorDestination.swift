import SwiftUI

enum MainCoordinatorDestination: Coordinatable {
    var id: UUID { .init() }
    case root
    case authentication
    case splash
    case onboarding
    
    var body: some View {
        switch self {
        case .root:
            AnyView(DependencyManager.shared.rootComponent.view)
        case .authentication:
            AnyView(DependencyManager.shared.rootComponent.authenticationComponent.feature.featureView)
        case .splash:
            SplashScreenView()
        case .onboarding:
            AnyView(DependencyManager.shared.rootComponent.onboardingComponent.feature.featureView)
        }
    }
}
