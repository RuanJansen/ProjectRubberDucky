//
//  AppleSignInManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/09/25.
//

import Foundation
import AuthenticationServices
import CryptoKit

protocol AppleSignInManager {
    func signInWithApple(onRequest request: ASAuthorizationAppleIDRequest)
    func signInWithApple(onCompletion completion: Result<ASAuthorization, any Error>, onSuccess: @escaping (Bool) -> Void, onSignedIn: @escaping (Bool) -> Void)
}

class ConcreteAppleSignInManager: AppleSignInManager {
    private let authenticateUserManager: AuthenticateUserManager
    private let firebaseAuthenticationManager: FirebaseAuthenticationManager

    private var currentNonce: String?

    init(authenticateUserManager: AuthenticateUserManager, firebaseAuthenticationManager: FirebaseAuthenticationManager) {
        self.authenticateUserManager = authenticateUserManager
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
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
                    self.authenticateUserManager.authenticate()
                }
            default:
                break

            }
        case .failure(let failure):
            print(failure.localizedDescription)
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
