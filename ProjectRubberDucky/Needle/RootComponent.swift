import SwiftUI
import NeedleFoundation
import Combine

class RootComponent: BootstrapComponent {

    @State var isAuthenticated = true
    private var anyCancelables = Set<AnyCancellable>()

    override init() {
        super.init()
        addSubscribers()
    }

    private func addSubscribers() {

        ///mimic authentication
        authenticationManager.getUserAuthenticated().sink { result in
            self.isAuthenticated = result
        }
        .store(in: &anyCancelables)
    }

    public var view: some View {
        RootView(feature: displayFeature())
    }

    private func displayFeature() -> Feature {
        if isAuthenticated {
            return tabViewContainerComponent.feature
        } else {
            return authenticationComponent.feature
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
