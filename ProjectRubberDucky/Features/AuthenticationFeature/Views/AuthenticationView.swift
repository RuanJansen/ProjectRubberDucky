//
//  AuthenticationView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/07.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

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
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presentContent(let dataModel):
                NavigationStack {
                    createContentView(using: dataModel)
                }
            case .error:
                EmptyView()
            case .none:
                EmptyView()
            }
        }
        .task {
            await provider.fetchContent()
        }
    }

    @ViewBuilder
    private func createContentView(using dataModel: AuthenticationDataModel) -> some View {
        VStack {
            Form {
                Section {
                    TextField("Username", text: $authenticationUsecase.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text("Username/Email")
                }

                Section {
                    SecureField("Password", text: $authenticationUsecase.password)
                } header: {
                    Text("Password")
                }
            }
            .frame(maxHeight: 200)
            .scrollDisabled(true)

            Spacer()

            Button {
                Task {
                    await authenticationUsecase.authenticate()
                }
            } label: {
                Text("Login")
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.primary)
                    .font(.title2)
                    .background {
                        RoundedRectangle(cornerRadius: 17.5)
                            .stroke(lineWidth: 1.0)
                    }
            }
            .padding(.horizontal)

            SignInWithAppleButton { request in
                authenticationUsecase.signInWithApple(onRequest: request)
            } onCompletion: { result in
                authenticationUsecase.signInWithApple(onCompletion: result)
            }


        }
        .navigationTitle(dataModel.title)
        .navigationDestination(isPresented: $isPresentingRegisterView) {
            createRegistrationView()
        }
    }

    @ViewBuilder
    private func createRegistrationView() -> some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Username", text: $authenticationUsecase.username)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    } header: {
                        Text("Username/Email")
                    }

                    Section {
                        SecureField("Password", text: $authenticationUsecase.password)
                        SecureField("Password", text: $authenticationUsecase.password)
                    } header: {
                        Text("Password")
                    } footer: {
                        Text("Re-enter password")
                    }
                }
                .scrollDisabled(false)
            }
            .navigationTitle("Register")
        }
    }
}
