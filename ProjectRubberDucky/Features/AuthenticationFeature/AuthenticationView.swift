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
    @Environment(AppStyling.self) var appStyling

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
                        .if(authenticationUsecase.showingInvalidEmailToast) { view in
                            view
                                .overlay {
                                    createToats(title: "Invalid Email", message: nil, image: Image(systemName: "exclamationmark.triangle"))
                                    }
                        }
                        .if(authenticationUsecase.showingInvalidPasswordToast) { view in
                            view
                                .overlay {
                                    createToats(title: "Invalid Password", message: "Your password: \n\u{2022} Must contain at least one letter.\n\u{2022} Must contain at least one digit.\n\u{2022} Must contain at least 8 characters long.\n\u{2022} Cannot contain any special characters.", image: Image(systemName: "exclamationmark.triangle"))
                                }
                        }
                        .if(authenticationUsecase.showingIsLoadingToast) { view in
                            view.overlay {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial))
                            }
                    }
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
    private func createToats(title: String, message: String?, image: Image) -> some View {
        VStack {
                image
                    .foregroundStyle(.red)
                    .font(.largeTitle)
                    .padding()
                Text(title)
                    .font(.title)

            if let message {
                Text(message)
                    .padding()
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial))
    }

    @ViewBuilder
    private func createContentView(using dataModel: AuthenticationDataModel) -> some View {
        VStack {
            appStyling.appIconImage
                .resizable()
                .clipShape(Circle())
                .frame(width: 100, height: 100)

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
            .padding(.bottom)

            Button {
                Task {
                    await authenticationUsecase.register()
                }
            } label: {
                Text("Sign in with Email")
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .font(.title2)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                    }
            }
            .padding(.horizontal)

            SignInWithAppleButton(.continue) { request in
                authenticationUsecase.signInWithApple(onRequest: request)
            } onCompletion: { result in
                authenticationUsecase.signInWithApple(onCompletion: result)
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 55)
            .padding()

            Spacer()
        }
        .navigationTitle(dataModel.title)
    }
}
