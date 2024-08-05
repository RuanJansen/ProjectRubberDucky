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
            case .presentContent(using: let tabs):
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
