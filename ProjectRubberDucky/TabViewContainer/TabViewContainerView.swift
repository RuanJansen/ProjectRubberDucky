import SwiftUI

struct TabViewContainerView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == [any Tabable] {
    @StateObject var provider: Provider

    @State private var showErrorAlert: Bool

    init(provider: Provider) {
        self._provider = StateObject(wrappedValue: provider)
        self.showErrorAlert = false
    }

    var body: some View {
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presentContent(using: let tabs):
                TabView {
                    ForEach(tabs, id: \.id) { tab in
                        AnyView(tab.feature.featureView)
                            .tabItem {
                                Label(tab.name, systemImage: tab.systemImage)
                            }
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
