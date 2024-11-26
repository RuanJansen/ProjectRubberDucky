import SwiftUI

struct TabViewContainerView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == [any Tabable] {
    @State var provider: Provider
    @State private var showErrorAlert: Bool
    @State private var tabSelection: Int
    init(provider: Provider) {
        self.provider = provider
        self.showErrorAlert = false
        self.tabSelection = 0
    }

    var body: some View {
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presenting(using: let tabs):
                TabView(selection: $tabSelection) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                        AnyView(tab.feature.featureView)
                            .tabItem {
                                Label(tab.name, systemImage: tab.systemImage)
                            }
                            .tag(index)
                    }
                }
            case .error:
                ProgressView()
            case .none:
                EmptyView()
            }
        }
        .task {
            await provider.fetchContent()
        }
    }
}

typealias Coordinatable = View & Identifiable & Hashable

@Observable
class Coordinator<CoordinatorPage: Coordinatable> {
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
    
    @State var coordinator = Coordinator<CoordinatorPage>()
    
    init(root: CoordinatorPage) {
        self.root = root
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination(for: CoordinatorPage.self) { $0 }
                .sheet(item: $coordinator.sheet) { $0 }
                .fullScreenCover(item: $coordinator.fullscreenCover) { $0 }
        }
        .environment(coordinator)
    }
}

enum MainCoordinatorViews: Coordinatable {
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
