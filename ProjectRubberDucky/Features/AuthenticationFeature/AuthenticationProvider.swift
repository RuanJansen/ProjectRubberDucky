import Foundation

@Observable
class AuthenticationProvider: FeatureProvider {
    typealias DataModel = AuthenticationDataModel

    public var viewState: ViewState<DataModel>

    private let contentProvider: AuthenticationContentProvidable
    private let authenticationManager: AuthenticationManager?

    init(contentProvider: AuthenticationContentProvidable,
         authenticationManager: AuthenticationManager? = nil) {
        self.contentProvider = contentProvider
        self.authenticationManager = authenticationManager
        self.viewState = .loading
    }

    func fetchContent() async {
        if let authenticationDataModel = await setupAuthenticationDataModel() {
            await MainActor.run {
                self.viewState = .presentContent(using: authenticationDataModel)
            }
        } else {
            await MainActor.run {
                self.viewState = .error
            }
        }
    }

    private func setupAuthenticationDataModel() async -> AuthenticationDataModel? {
        if let setupSignInDataModel = await setupSignInDataModel(),
           let setupRegisterDataModel = await setupRegisterDataModel() {
            return AuthenticationDataModel(signIn: setupSignInDataModel,
                                           register: setupRegisterDataModel)
        } else {
            return nil
        }
    }
    
    private func setupSignInDataModel() async -> AuthenticationSignInDataModel? {
        let pageTitle = await contentProvider.fetchLoginPageTitle()
        let sectionHeader1 = await contentProvider.fetchLoginSectionHeader1()
        let sectionHeader2 = await contentProvider.fetchLoginSectionHeader2()
        let primaryAction = await contentProvider.fetchLoginPrimaryAction()
        let secondaryAction = await contentProvider.fetchLoginSecondaryAction()

        return AuthenticationSignInDataModel(pageTitle: pageTitle,
                                             sectionHeader1: sectionHeader1,
                                             sectionHeader2: sectionHeader2,
                                             primaryAction: primaryAction,
                                             secondaryAction: secondaryAction)
    }

    private func setupRegisterDataModel() async -> AuthenticationRegisterDataModel? {
        let pageTitle = await contentProvider.fetchRegisterPageTitle()
        let sectionHeader1 = await contentProvider.fetchRegisterSectionHeader1()
        let sectionHeader2 = await contentProvider.fetchRegisterSectionHeader2()
        let primaryAction = await contentProvider.fetchRegisterPrimaryAction()

        return AuthenticationRegisterDataModel(pageTitle: pageTitle,
                                               sectionHeader1: sectionHeader1,
                                               sectionHeader2: sectionHeader2,
                                               primaryAction: primaryAction)

    }
}
