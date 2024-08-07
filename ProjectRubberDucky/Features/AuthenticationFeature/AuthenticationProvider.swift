import Foundation

@Observable
class AuthenticationProvider: FeatureProvider {
    typealias DataModel = AuthenticationDataModel

    public var viewState: ViewState<DataModel>

    private let authenticationManager: AuthenticationManager?

    init(authenticationManager: AuthenticationManager? = nil) {
        self.authenticationManager = authenticationManager
        self.viewState = .loading
    }

    func fetchContent() async {
        self.viewState = .presentContent(using: setupAuthenticationDataModel())
    }

    private func setupAuthenticationDataModel() -> AuthenticationDataModel {
        AuthenticationDataModel(title: "Log in")
    }
}
