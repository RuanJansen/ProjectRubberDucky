//
//  AuthenticationView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/07.
//

import SwiftUI

struct AuthenticationView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == AuthenticationDataModel{
    @State var provider: Provider
    @State var authenticationUsecase: AuthenticationUsecase
    @State private var isPresentingRegisterView: Bool

    init(provider: Provider, authenticationUsecase: AuthenticationUsecase) {
        self.provider = provider
        self.authenticationUsecase = authenticationUsecase
        self.isPresentingRegisterView = false
    }

    var body: some View {
        NavigationStack {
            createContentView()
        }
    }
}

extension AuthenticationView {
    @ViewBuilder
    private func createContentView() -> some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                TextField("Username", text: $authenticationUsecase.username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
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
                Task {
                    await authenticationUsecase.authenticate()
                }
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
        }
    }
}
