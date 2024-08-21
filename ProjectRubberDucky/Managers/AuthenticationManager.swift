import Foundation
import Combine
import AuthenticationServices
import CryptoKit

enum AuthenticationStatus {
    case userAuthenticated
    case userNotAuthenticated
    case userNotFound
}

//@Observable
class AuthenticationManager: ObservableObject {
    @Published public var isAuthenticated: Bool
    var currentNonce: String?


    private let firebaseAuthenticationManager: FirebaseAuthenticationManager

    private let firestoreUserManager: FirestoreUserManager

    init(firebaseAuthenticationManager: FirebaseAuthenticationManager,
         firestoreUserManager: FirestoreUserManager) {
        self.isAuthenticated = false
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
        self.firestoreUserManager = firestoreUserManager
        self.authenticateUser()
    }

    public func authenticateUser() {
        self.isAuthenticated = firebaseAuthenticationManager.checkUserIsAuthenticated()
    }

    public func createUser(email: String, password: String) async {
        guard let user = await firebaseAuthenticationManager.createUser(email: email, password: password) else { return }
        do {
            try await firestoreUserManager.createUser(user: user)
            isAuthenticated = true
        } catch {
            isAuthenticated = false
            deleteUser()
        }
    }

    public func signIn(email: String, password: String) async throws {
        guard let user = await firebaseAuthenticationManager.signIn(email: email, password: password) else { return }
        do {
            try await firestoreUserManager.createUser(user: user)
            isAuthenticated = true
        } catch { }
    }

    public func login() {
        let authUser = try? self.firebaseAuthenticationManager.getAuthenticatedUser()

        if authUser != nil {
            self.isAuthenticated = true
        } else {
            self.isAuthenticated = false
        }
    }

    public func logOut() async {
        do {
            try await firebaseAuthenticationManager.logOut()
            isAuthenticated = false
        } catch {
            isAuthenticated = true
            return
        }
    }

    public func deleteUser() {
        firebaseAuthenticationManager.deleteAccount() { user in
            self.firestoreUserManager.deleteUser(user: user)
            self.isAuthenticated = false
        }

    }

    public func signInWithApple(onRequest request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }

    public func signInWithApple(onCompletion completion: Result<ASAuthorization, any Error>, onSuccess: @escaping (Bool) -> Void, onSignedIn: @escaping (Bool) -> Void) {
        switch completion {
        case .success(let authResults):
            onSuccess(true)
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

                firebaseAuthenticationManager.signInWithApple(idToken: idTokenString, rawNonce: nonce) {
                    onSignedIn(true)
                    let authUser = try? self.firebaseAuthenticationManager.getAuthenticatedUser()

                    if authUser != nil {
                        self.isAuthenticated = true
                    } else {
                        self.isAuthenticated = false
                    }
                }
            default:
                break

            }
        default:
            break
        }
    }

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
