import SwiftUI
import Observation
import AuthenticationServices
import CryptoKit

@Observable
class AuthenticationUsecase {
    private let appleSignInManager: AppleSignInManager
    private let emailSignInManager: EmailSignInManager
    private let emailRegistrationManager: EmailRegistrationManager

    var email: String
    var password: String
    var rePassword: String
    var displayName: String

    var showingInvalidEmail: Bool
    var showingInvalidPassword: Bool
    var showingPasswordsMissmatch: Bool

    var showingIsLoadingToast: Bool

    init(appleSignInManager: AppleSignInManager,
         emailSignInManager: EmailSignInManager,
         emailRegistrationManager: EmailRegistrationManager) {
        self.appleSignInManager = appleSignInManager
        self.emailSignInManager = emailSignInManager
        self.emailRegistrationManager = emailRegistrationManager

        self.email = String()
        self.password = String()
        self.rePassword = String()
        self.displayName = String()
        self.showingInvalidEmail = false
        self.showingInvalidPassword = false
        self.showingPasswordsMissmatch = false
        self.showingIsLoadingToast = false
    }

    public func register() async {
        guard isValidEmail(email: email) else {
            self.showingInvalidEmail = true
            return
        }

        guard isValidPassword(password) else {
            self.showingInvalidPassword = true
            return
        }

        guard passwordsMatch() else {
            self.showingPasswordsMissmatch = true
            return
        }

        showingIsLoadingToast = true

        do {
            await emailRegistrationManager.createUser(email: email, password: password, displayName: displayName)
            email = String()
            password = String()
            displayName = String()
            showingIsLoadingToast = false
        } catch {
            // error
            print("Register failed")
            showingIsLoadingToast = false
        }
    }

    public func signIn() async {
        guard isValidEmail(email: email) else {
            self.showingInvalidEmail = true
            return
        }

        guard isValidPassword(password) else {
            self.showingInvalidPassword = true
            return
        }

        showingIsLoadingToast = true

        do {
            try await emailSignInManager.signIn(email: email, password: password)
            password = String()
            showingIsLoadingToast = false
        } catch {
            // error
            print("Sign in failed")
            showingIsLoadingToast = false
        }
    }

    public func signInWithApple(onRequest request: ASAuthorizationAppleIDRequest) {
        appleSignInManager.signInWithApple(onRequest: request)
    }

    public func signInWithApple(onCompletion completion: Result<ASAuthorization, any Error>) {
        appleSignInManager.signInWithApple(onCompletion: completion) { isSuccessful in
            self.showingIsLoadingToast = isSuccessful
        } onSignedIn: { isSignedIn in
            self.showingIsLoadingToast = !isSignedIn
        }
    }

    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)

//        The password must contain at least one letter.
//        The password must contain at least one digit.
//        The password must be at least 8 characters long.
//        The password can only contain letters and digits (no special characters).
    }

    private func passwordsMatch() -> Bool {
        return password == rePassword
    }

    public func fetchInvalidEmailRDAlertModel() -> RDAlertModel {
        RDAlertModel(title: "Invalid Email",
                     message: "Please enter a valid email address.",
                     buttons: [RDAlertButtonModel(title: "Okay", action: {})])
    }

    public func fetchInvalidPasswordRDAlertModel() -> RDAlertModel {
        RDAlertModel(title: "Invalid Password",
                     message: "Make sure your password contains at least one letter, at least one digit, is at least 8 characters long and does not contain any special characters.",
                     buttons: [RDAlertButtonModel(title: "Okay", action: {})])
    }

    public func fetchPasswordsMissmatchRDAlertModel() -> RDAlertModel {
        RDAlertModel(title: "Passwords missmatch",
                     message: "Your passwords are not matching.",
                     buttons: [RDAlertButtonModel(title: "Okay", action: {})])
    }
}
