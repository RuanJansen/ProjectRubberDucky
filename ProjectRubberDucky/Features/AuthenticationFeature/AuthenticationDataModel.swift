import Foundation

struct AuthenticationDataModel {
    let signIn: AuthenticationSignInDataModel
    let register: AuthenticationRegisterDataModel
}

struct AuthenticationSignInDataModel {
    let pageTitle: String

    let sectionHeader1: String
    let textFieldDefault1: String

    let sectionHeader2: String
    let textFieldDefault2: String
    
    let primaryAction: String
    let secondaryAction: String
}

struct AuthenticationRegisterDataModel {
    let pageTitle: String

    let sectionHeader1: String
    let textFieldDefault1: String

    let sectionHeader2: String
    let textFieldDefault2: String

    let sectionHeader3: String
    let textFieldDefault3: String

    let sectionHeader4: String
    let textFieldDefault4: String

    let primaryAction: String
}
