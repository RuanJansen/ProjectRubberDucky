import SwiftUI
import FirebaseAuth
import Observation
import AuthenticationServices
import CryptoKit

@Observable
class AuthenticationUsecase {
    private let authenticationManager: AuthenticationManager

    var email: String
    var password: String

    var showingInvalidEmailToast: Bool
    var showingInvalidPasswordToast: Bool
    var showingIsLoadingToast: Bool

    var currentNonce: String?

    init(authenticationManager: AuthenticationManager) {
        self.authenticationManager = authenticationManager
        self.email = String()
        self.password = String()
        self.showingInvalidEmailToast = false
        self.showingInvalidPasswordToast = false
        self.showingIsLoadingToast = false
    }

    public func authenticate() async {
        authenticationManager.login()
    }

    public func register() async {
//        guard !email.isEmpty, !password.isEmpty else {
//            // validate
//            return
//        }

        guard isValidEmail(email: email) else {
            self.showingInvalidEmailToast = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.showingInvalidEmailToast = false
            }

            return
        }

        guard isValidPassword(password) else {
            self.showingInvalidPasswordToast = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.showingInvalidPasswordToast = false
            }

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
            showingIsLoadingToast = false

        }
    }

    public func signInWithApple(onRequest request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }

    public func signInWithApple(onCompletion completion: Result<ASAuthorization, any Error>) {
        switch completion {
        case .success(let authResults):
            showingIsLoadingToast = true
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:

                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }

                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if (error != nil) {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error?.localizedDescription as Any)
                        return
                    }
                    print("signed in")
                    self.showingIsLoadingToast = false
                    self.authenticationManager.login()
                }

                print("\(String(describing: Auth.auth().currentUser?.uid))")
            default:
                break

            }
        default:
            break
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
}

extension AuthenticationUsecase {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
