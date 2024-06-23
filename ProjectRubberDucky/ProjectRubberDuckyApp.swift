import SwiftUI

@main
struct ProjectRubberDuckyApp: App {
    let rootComponent: RootComponent

    init() {
        registerProviderFactories()
        self.rootComponent = DependencyContainer.shared.rootComponent
    }

    var body: some Scene {
        WindowGroup {
            rootComponent.view
        }
    }
}

class DependencyContainer {
    static let shared = DependencyContainer()

    let rootComponent: RootComponent

    init() {
        self.rootComponent = RootComponent()
    }
}
