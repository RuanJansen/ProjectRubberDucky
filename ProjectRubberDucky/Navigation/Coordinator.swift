import SwiftUI

typealias Coordinatable = View & Identifiable & Hashable

@Observable
class Coordinator<CoordinatorPage: Coordinatable> {
    let id: UUID = UUID()
    var path: NavigationPath = NavigationPath()
    var sheet: CoordinatorPage?
    var fullscreenCover: CoordinatorPage?
    var splash: CoordinatorPage?
    var selectedTabIndex: Int = 0

    enum PushType {
        case link
        case sheet
        case fullscreenCover
    }
    
    enum PopType {
        case link(last: Int)
        case sheet
        case fullscreenCover
    }
    
    func push(_ page: CoordinatorPage, type: PushType = .link) {
        switch type {
        case .link:
            path.append(page)
        case .sheet:
            sheet = page
        case .fullscreenCover:
            fullscreenCover = page
        }
    }
    
    func pop(type: PopType = .link(last: 1)) {
        switch type {
        case .link(last: let last):
            path.removeLast(last)
        case .sheet:
            sheet = nil
        case .fullscreenCover:
            fullscreenCover = nil
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func splash(_ page: CoordinatorPage) {
        splash = page
    }
    
    func switchTab(to index: Int) {
            selectedTabIndex = index
        }
}

struct CoordinatorStack<CoordinatorPage: Coordinatable>: View {
    let root: CoordinatorPage
    
    @State var coordinator: Coordinator<CoordinatorPage>
    
    init(root: CoordinatorPage,
         coordinator: Coordinator<CoordinatorPage> = .init()) {
        self.root = root
        self.coordinator = coordinator
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            if let splash = coordinator.splash {
                splash
            } else {
                root
                    .navigationDestination(for: CoordinatorPage.self) { $0 }
                    .sheet(item: $coordinator.sheet) { $0 }
                    .fullScreenCover(item: $coordinator.fullscreenCover) { $0 }
            }
        }
    }
}
