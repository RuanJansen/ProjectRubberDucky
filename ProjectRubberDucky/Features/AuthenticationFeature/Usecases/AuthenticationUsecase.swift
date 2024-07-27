import SwiftUI
import Observation

@Observable
class AuthenticationUsecase {
    private let authenticationManager: AuthenticationManager?

    var username: String
    var password: String

    init(authenticationManager: AuthenticationManager? = nil) {
        self.authenticationManager = authenticationManager
        self.username = String()
        self.password = String()
    }

    public func authenticate() async {
        await authenticationManager?.authenticatedUser(with: username, and: password)
    }
}
