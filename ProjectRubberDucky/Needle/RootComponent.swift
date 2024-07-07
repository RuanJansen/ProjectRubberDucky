import SwiftUI
import NeedleFoundation
import Combine

class RootComponent: BootstrapComponent {

    @State var isAuthenticated = false
    private var anyCancelables = Set<AnyCancellable>()

    override init() {
        super.init()
        addSubscribers()
    }

    private func addSubscribers() {
        authenticationManager.$userIsAuthenticated.sink { result in
            self.isAuthenticated = result
        }
        .store(in: &anyCancelables)
    }

    public var view: some View {
        if isAuthenticated {
            RootView(feature: tabViewContainerComponent.feature)
        } else {
            RootView(feature: authenticationComponent.feature)
        }
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
