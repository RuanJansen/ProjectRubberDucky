import SwiftUI
import Observation
import AuthenticationServices
import CryptoKit

@Observable
class AuthenticationUsecase {
    private let authenticationManager: AuthenticationManager

    var email: String
    var password: String
    var username: String

    var showingInvalidEmail: Bool
    var showingInvalidPassword: Bool
    var showingIsLoadingToast: Bool

    init(authenticationManager: AuthenticationManager) {
        self.authenticationManager = authenticationManager
        self.email = String()
        self.password = String()
        self.username = String()
        self.showingInvalidEmail = false
        self.showingInvalidPassword = false
        self.showingIsLoadingToast = false
    }

    public func authenticate() async {
        authenticationManager.login()
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

        showingIsLoadingToast = true

        do {
            let returnedUserData: () = try await authenticationManager.createUser(email: email, password: password)
            email = ""
            password = ""
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
            let returnedUserData: () = try await authenticationManager.signIn(email: email, password: password)
            password = String()
            showingIsLoadingToast = false
        } catch {
            // error
            print("Sign in failed")
            showingIsLoadingToast = false

        }
    }

    public func signInWithApple(onRequest request: ASAuthorizationAppleIDRequest) {
        authenticationManager.signInWithApple(onRequest: request)
    }

    public func signInWithApple(onCompletion completion: Result<ASAuthorization, any Error>) {
        authenticationManager.signInWithApple(onCompletion: completion) { isSuccessful in
            self.showingIsLoadingToast = isSuccessful
        } onSignedIn: { isSignedIn in
            self.showingIsLoadingToast = !isSignedIn
        }
    }


    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)

//        The password must contain at least one letter.
//        The password must contain at least one digit.
//        The password must be at least 8 characters long.
//        The password can only contain letters and digits (no special characters).
    }

    func fetchInvalidEmailRDAlertModel() -> RDAlertModel {
        RDAlertModel(title: "Invalid Email",
                     message: "Please enter a valid email address.",
                     buttons: [RDAlertButtonModel(title: "Okay", action: {})])
    }

    func fetchInvalidPasswordRDAlertModel() -> RDAlertModel {
        RDAlertModel(title: "Invalid Password",
                     message: "Make sure your password contains at least one letter, at least one digit, is at least 8 characters long and does not contain any special characters.",
                     buttons: [RDAlertButtonModel(title: "Okay", action: {})])
    }
}
