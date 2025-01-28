import SwiftUI

struct TabViewContainerView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == [any Tabable] {
    @State var provider: Provider
    @State private var showErrorAlert: Bool
    @State private var tabSelection: Int
    @State private var navigationCoordinator: Coordinator<MainCoordinatorDestination>

    init(provider: Provider,
         navigationCoordinator: Coordinator<MainCoordinatorDestination>) {
        self.provider = provider
        self.showErrorAlert = false
        self.navigationCoordinator = navigationCoordinator
        self.tabSelection = 0
    }

    var body: some View {
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presenting(using: let tabs):
                TabView(selection: $navigationCoordinator.selectedTabIndex) {
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
