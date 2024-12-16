import SwiftUI


class UserDefaultsManager {
    @AppStorage("hasSeenboarding") var hasSeenboarding: Bool = false
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
}
