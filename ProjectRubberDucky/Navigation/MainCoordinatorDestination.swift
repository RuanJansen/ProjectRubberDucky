import SwiftUI

enum MainCoordinatorDestination: Coordinatable {
    var id: UUID { .init() }
    case rootDestination
    case authenticationDestination
    case splashDestination
    case onboardingDestination
    
    var body: some View {
        switch self {
        case .rootDestination:
            AnyView(DependencyManager.shared.rootComponent.view)
        case .authenticationDestination:
            AnyView(DependencyManager.shared.rootComponent.authenticationComponent.feature.featureView)
        case .splashDestination:
            AnyView(DependencyManager.shared.rootComponent.splashScreen)
        case .onboardingDestination:
            AnyView(DependencyManager.shared.rootComponent.onboardingComponent.feature.featureView)
        }
    }
}
