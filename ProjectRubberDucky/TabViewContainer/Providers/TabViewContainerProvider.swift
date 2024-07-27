import NeedleFoundation
import SwiftUI

@Observable
class TabViewContainerProvider: FeatureProvider {
    public typealias DataModel = [any Tabable]

    public var viewState: ViewState<DataModel>

    private let tabs: [any Tabable]?

    init(tabs: [any Tabable]?) {
        self.viewState = .loading
        self.tabs = tabs
    }

    public func fetchContent() {
        if let tabs {
            self.viewState = .presentContent(using: tabs)
        } else {
            self.viewState = .error
        }
    }
}
