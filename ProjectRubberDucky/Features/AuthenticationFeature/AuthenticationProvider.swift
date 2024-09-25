import Foundation

@Observable
class AuthenticationProvider: FeatureProvider {
    typealias DataModel = AuthenticationDataModel

    public var viewState: ViewState<DataModel>

    private let contentProvider: AuthenticationContentProvidable

    init(contentProvider: AuthenticationContentProvidable) {
        self.contentProvider = contentProvider
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
        let textFieldDefault1 = await contentProvider.fetchLoginTextFieldDefault1()
        let sectionHeader2 = await contentProvider.fetchLoginSectionHeader2()
        let textFieldDefault2 = await contentProvider.fetchLoginTextFieldDefault2()
        let primaryAction = await contentProvider.fetchLoginPrimaryAction()
        let secondaryAction = await contentProvider.fetchLoginSecondaryAction()

        return AuthenticationSignInDataModel(pageTitle: pageTitle,
                                             sectionHeader1: sectionHeader1,
                                             textFieldDefault1: textFieldDefault1,
                                             sectionHeader2: sectionHeader2,
                                             textFieldDefault2: textFieldDefault2,
                                             primaryAction: primaryAction,
                                             secondaryAction: secondaryAction)
    }

    private func setupRegisterDataModel() async -> AuthenticationRegisterDataModel? {
        let pageTitle = await contentProvider.fetchRegisterPageTitle()
        let sectionHeader1 = await contentProvider.fetchRegisterSectionHeader1()
        let textFieldDefault1 = await contentProvider.fetchRegistrerTextFieldDefault1()
        let sectionHeader2 = await contentProvider.fetchRegisterSectionHeader2()
        let textFieldDefault2 = await contentProvider.fetchRegistrerTextFieldDefault2()
        let sectionHeader3 = await contentProvider.fetchRegisterSectionHeader3()
        let textFieldDefault3 = await contentProvider.fetchRegistrerTextFieldDefault3()
        let sectionHeader4 = await contentProvider.fetchRegisterSectionHeader4()
        let textFieldDefault4 = await contentProvider.fetchRegistrerTextFieldDefault4()
        let primaryAction = await contentProvider.fetchRegisterPrimaryAction()

        return AuthenticationRegisterDataModel(pageTitle: pageTitle,
                                               sectionHeader1: sectionHeader1,
                                               textFieldDefault1: textFieldDefault1,
                                               sectionHeader2: sectionHeader2,
                                               textFieldDefault2: textFieldDefault2,
                                               sectionHeader3: sectionHeader3,
                                               textFieldDefault3: textFieldDefault3,
                                               sectionHeader4: sectionHeader4,
                                               textFieldDefault4: textFieldDefault4,
                                               primaryAction: primaryAction)
    }
}
