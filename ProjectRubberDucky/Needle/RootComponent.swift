import SwiftUI
import NeedleFoundation

class RootComponent: BootstrapComponent {
    @State var isAuthenticated: Bool = false

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
