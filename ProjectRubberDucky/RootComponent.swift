import Foundation
import SwiftUI
import NeedleFoundation

class RootComponent: BootstrapComponent {
    public var view: some View {
        RootView(feature: tabViewContainerComponent.feature)
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
