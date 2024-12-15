import SwiftUI

typealias Coordinatable = View & Identifiable & Hashable

//@Observable
class Coordinator<CoordinatorPage: Coordinatable>: ObservableObject {
    var path: NavigationPath = NavigationPath()
    var sheet: CoordinatorPage?
    var fullscreenCover: CoordinatorPage?
    
    enum PushType {
        case link
        case sheet
        case fullscreenCover
    }
    
    enum PopType {
        case link(last: Int)
        case sheet
        case fullscreenCover
    }
    
    func push(_ page: CoordinatorPage, type: PushType = .link) {
        switch type {
        case .link:
            path.append(page)
        case .sheet:
            sheet = page
        case .fullscreenCover:
            fullscreenCover = page
        }
    }
    
    func pop(type: PopType = .link(last: 1)) {
        switch type {
        case .link(last: let last):
            path.removeLast(last)
        case .sheet:
            sheet = nil
        case .fullscreenCover:
            fullscreenCover = nil
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

struct CoordinatorStack<CoordinatorPage: Coordinatable>: View {
    let root: CoordinatorPage
    
    @State var coordinator: Coordinator<CoordinatorPage>
    
    init(root: CoordinatorPage,
         coordinator: Coordinator<CoordinatorPage> = .init()) {
        self.root = root
        self.coordinator = coordinator
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination(for: CoordinatorPage.self) { $0 }
                .sheet(item: $coordinator.sheet) { $0 }
                .fullScreenCover(item: $coordinator.fullscreenCover) { $0 }
        }
    }
}

enum MainCoordinatorViews: Coordinatable {
    var id: UUID { .init() }
    case home
    case authentication
    case splash
    case onboarding
    
    var body: some View {
        switch self {
        case .home:
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
