import Foundation

struct AuthenticationDataModel {
    let signIn: AuthenticationSignInDataModel
    let register: AuthenticationRegisterDataModel
}

struct AuthenticationSignInDataModel {
    let pageTitle: String
    let sectionHeader1: String
    let sectionHeader2: String
    let primaryAction: String
    let secondaryAction: String
}

struct AuthenticationRegisterDataModel {
    let pageTitle: String
    let sectionHeader1: String
    let sectionHeader2: String
    let primaryAction: String
}
