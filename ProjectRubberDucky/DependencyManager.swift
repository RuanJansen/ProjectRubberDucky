import Foundation
import NeedleFoundation

class DependencyManager {
    static let shared = DependencyManager()

    let rootComponent: RootComponent

    private init() {
        self.rootComponent = RootComponent()
    }
}
