import SwiftUI

class AuthenticationUsecase: ObservableObject {
    private let authenticationManager: AuthenticationManager?

    @Published var username: String
    @Published var password: String

    init(authenticationManager: AuthenticationManager? = nil) {
        self.authenticationManager = authenticationManager
        self.username = String()
        self.password = String()
    }

    public func authenticate() {
        authenticationManager?.authenticatedUser(with: username.lowercased(), and: password)
    }
}
