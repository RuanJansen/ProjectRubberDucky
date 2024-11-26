//
//  AppleSignInManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/11/22.
//

import Foundation
import CryptoKit
import AuthenticationServices

protocol AppleSignInManageable: ObservableObject {
    func signInWithApple(onRequest request: ASAuthorizationAppleIDRequest)
    func signInWithApple(onCompletion completion: Result<ASAuthorization, any Error>, onSuccess: @escaping (Bool) -> Void, onSignedIn: @escaping (Bool) -> Void)
}

class AppleSignInManager: AppleSignInManageable {
    private var currentNonce: String?
    private let userAuthenticationManager: UserAuthenticationManageable
    private let serviceAuthenticationManager: UserAuthenticationAuthenticatable
    private let userDatabaseManager: DatabaseUserCreateable

    init(userAuthenticationManager: UserAuthenticationManageable,
         serviceAuthenticationManager: UserAuthenticationAuthenticatable,
         userDatabaseManager: DatabaseUserCreateable) {
        self.userAuthenticationManager = userAuthenticationManager
        self.serviceAuthenticationManager = serviceAuthenticationManager
        self.userDatabaseManager = userDatabaseManager
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

                serviceAuthenticationManager.signInWithApple(idToken: idTokenString, rawNonce: nonce) {
                    onSignedIn(true)
                    self.userAuthenticationManager.authenticate()
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
