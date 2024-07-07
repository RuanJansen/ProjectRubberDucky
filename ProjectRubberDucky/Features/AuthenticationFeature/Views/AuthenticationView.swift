//
//  AuthenticationView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/07.
//

import SwiftUI

struct AuthenticationView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == AuthenticationDataModel{
    @StateObject var provider: Provider
    @StateObject var authenticationUsecase: AuthenticationUsecase

    @State private var isPresentingRegisterView: Bool

    init(provider: Provider, authenticationUsecase: AuthenticationUsecase) {
        self._provider = StateObject(wrappedValue: provider)
        self._authenticationUsecase = StateObject(wrappedValue: authenticationUsecase)
        self.isPresentingRegisterView = false
    }

    var body: some View {
        NavigationStack {
            createContentView()
        }
    }
}

#if os(iOS)
extension AuthenticationView {
    @ViewBuilder
    private func createContentView() -> some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                TextField("Username", text: $authenticationUsecase.username)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(lineWidth: 1.0)
                    }
                SecureField("Password", text: $authenticationUsecase.password)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(lineWidth: 1.0)
                    }
            }

            Button {
                isPresentingRegisterView = true
            } label: {
                Text("Not a member yet?")
            }

            Spacer()

            Button {
                authenticationUsecase.authenticate()
            } label: {
                Text("Login")
                    .font(.title2)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(lineWidth: 1.0)
                    }
            }

        }
        .padding()
        .navigationTitle("Login")
        .navigationDestination(isPresented: $isPresentingRegisterView) {
//            createRegisterView()
        }
    }

//    @ViewBuilder
//    private func createRegisterView() -> some View {
//        VStack(spacing: 30) {
//            VStack(spacing: 15) {
//                TextField("Username", text: $authenticationUsecase.username)
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius: 25.0)
//                            .stroke(lineWidth: 1.0)
//                    }
//                SecureField("Password", text: $authenticationUsecase.password)
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius: 25.0)
//                            .stroke(lineWidth: 1.0)
//                    }
//            }
//
//            Spacer()
//
//            Button {
//
//            } label: {
//                Text("Register")
//                    .font(.title2)
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius: 25.0)
//                            .stroke(lineWidth: 1.0)
//                    }
//            }
//        }
//        .padding()
//        .navigationTitle("Create Account")
//    }
}
#endif
