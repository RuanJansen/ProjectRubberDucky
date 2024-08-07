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
                    TextField("Email", text: $authenticationUsecase.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text("Email")
                }

                Section {
                    SecureField("Password", text: $authenticationUsecase.password)
                } header: {
                    Text("Password")
                }
            }
            .frame(maxHeight: 200)
            .scrollDisabled(true)


            Button {
                Task {
                    await authenticationUsecase.register()
                }
            } label: {
                Text("Sign in with Email")
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.primary)
                    .font(.title2)
                    .background {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 1.0)
                    }
            }
            .padding(.horizontal)

            SignInWithAppleButton { request in
                authenticationUsecase.signInWithApple(onRequest: request)
            } onCompletion: { result in
                authenticationUsecase.signInWithApple(onCompletion: result)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 1.0)
            }
            .padding()

            Spacer()
        }
        .navigationTitle(dataModel.title)
    }
}
