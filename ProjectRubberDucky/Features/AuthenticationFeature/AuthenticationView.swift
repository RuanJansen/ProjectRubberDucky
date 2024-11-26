//
//  AuthenticationView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/07.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct AuthenticationView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == AuthenticationDataModel{
    @Environment(AppStyling.self) var appStyling

    @State var provider: Provider
    @State var authenticationUsecase: AuthenticationUsecase
    @State private var isPresentingRegisterView: Bool

    @FocusState private var loginFocusedField: LoginFocusField?
    @FocusState private var registerFocusedField: RegisterFocusField?

    enum LoginFocusField {
        case email
        case password
        case primaryButton
        case secondaryButton
    }

    enum RegisterFocusField {
        case email
        case password
        case rePassword
        case displayName
        case primaryButton
    }

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
            case .presenting(let dataModel):
                NavigationStack {
                    createContentView(using: dataModel)
                        .alert(authenticationUsecase.fetchInvalidEmailRDAlertModel().title,
                               isPresented: $authenticationUsecase.showingInvalidEmail,
                               actions: {
                            ForEach(authenticationUsecase.fetchInvalidEmailRDAlertModel().buttons, id: \.id) { button in
                                Button(role: button.role) {
                                    button.action()
                                } label: {
                                    Text(button.title)
                                }
                            }
                        },
                               message: {
                            if let message = authenticationUsecase.fetchInvalidEmailRDAlertModel().message {
                                Text(message)
                            }
                        })
                        .alert(authenticationUsecase.fetchInvalidPasswordRDAlertModel().title,
                               isPresented: $authenticationUsecase.showingInvalidPassword, actions: {
                            ForEach(authenticationUsecase.fetchInvalidPasswordRDAlertModel().buttons, id: \.id) { button in
                                Button(role: button.role) {
                                    button.action()
                                } label: {
                                    Text(button.title)
                                }
                            }
                        }, message: {
                            if let message = authenticationUsecase.fetchInvalidPasswordRDAlertModel().message {
                                Text(message)
                            }
                        })
                        .alert(authenticationUsecase.fetchPasswordsMissmatchRDAlertModel().title,
                               isPresented: $authenticationUsecase.showingPasswordsMissmatch, actions: {
                            ForEach(authenticationUsecase.fetchPasswordsMissmatchRDAlertModel().buttons, id: \.id) { button in
                                Button(role: button.role) {
                                    button.action()
                                } label: {
                                    Text(button.title)
                                }
                            }
                        }, message: {
                            if let message = authenticationUsecase.fetchPasswordsMissmatchRDAlertModel().message {
                                Text(message)
                            }
                        })
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
    private func createLoadingToats() -> some View {
        ProgressView()
            .frame(width: 100, height: 100)
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
                    TextField(dataModel.signIn.textFieldDefault1, text: $authenticationUsecase.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($loginFocusedField, equals: .email)
                } header: {
                    Text(dataModel.signIn.sectionHeader1)
                }

                Section {
                    SecureField(dataModel.signIn.textFieldDefault2, text: $authenticationUsecase.password)
                        .submitLabel(.go)
                        .focused($loginFocusedField, equals: .password)
                } header: {
                    Text(dataModel.signIn.sectionHeader2)
                }
            }
            .frame(maxHeight: 200)
            .scrollDisabled(true)
            .padding(.bottom)

            RDButton(.action({
                Task {
                    await authenticationUsecase.signIn()
                }
            }), label: {
                Text(dataModel.signIn.primaryAction)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .font(.title2)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                    }
            })
            .focused($loginFocusedField, equals: .primaryButton)
            .padding(.horizontal)
            .padding(.bottom)

            RDButton(.navigate(hideChevron: true) {
                AnyView(createRegstraterView(dataModel: dataModel.register))
            }, label: {
                Text(dataModel.signIn.secondaryAction)
            })
            .focused($loginFocusedField, equals: .secondaryButton)
            .padding(.bottom)

            SignInWithAppleButton(.continue) { request in
                authenticationUsecase.signInWithApple(onRequest: request)
            } onCompletion: { result in
                authenticationUsecase.signInWithApple(onCompletion: result)
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 55)
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle(dataModel.signIn.pageTitle)
        .ignoresSafeArea(.keyboard)
        .if(authenticationUsecase.showingIsLoadingToast) { view in
            view.overlay {
                createLoadingToats()
            }
        }
        .onSubmit {
            switch loginFocusedField {
            case .email:
                loginFocusedField = .password
            case .password:
                Task {
                    await authenticationUsecase.signIn()
                }
            case .primaryButton:
                break
            case .secondaryButton:
                break
            case nil:
                break
            }
        }
    }

    @ViewBuilder
    private func createRegstraterView(dataModel: AuthenticationRegisterDataModel) -> some View {
        VStack {
            Form {
                Section {
                    TextField(dataModel.textFieldDefault1, text: $authenticationUsecase.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($registerFocusedField, equals: .email)
                } header: {
                    Text(dataModel.sectionHeader1)
                }

                Section {
                    SecureField(dataModel.textFieldDefault2, text: $authenticationUsecase.password)
                        .submitLabel(.next)
                        .focused($registerFocusedField, equals: .password)
                } header: {
                    Text(dataModel.sectionHeader2)
                }

                Section {
                    SecureField(dataModel.textFieldDefault3, text: $authenticationUsecase.rePassword)
                        .submitLabel(.next)
                        .focused($registerFocusedField, equals: .rePassword)
                } header: {
                    Text(dataModel.sectionHeader3)
                }

                Section {
                    TextField(dataModel.textFieldDefault4, text: $authenticationUsecase.displayName)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.go)
                        .focused($registerFocusedField, equals: .displayName)
                } header: {
                    Text(dataModel.sectionHeader4)
                }
            }
            .padding(.bottom)

            RDButton(.action {
                Task {
                    await authenticationUsecase.register()
                }
            }, label: {
                Text(dataModel.primaryAction)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .font(.title2)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                    }
            })
            .focused($registerFocusedField, equals: .primaryButton)
            .padding(.bottom)
            .padding(.horizontal)
        }
        .navigationTitle(dataModel.pageTitle)
        .ignoresSafeArea(.keyboard)
        .if(authenticationUsecase.showingIsLoadingToast) { view in
            view.overlay {
                createLoadingToats()
            }
        }
        .onSubmit {
            switch registerFocusedField {
            case .email:
                registerFocusedField = .password
            case .password:
                registerFocusedField = .rePassword
            case .rePassword:
                registerFocusedField = .displayName
            case .displayName:
                Task {
                    await authenticationUsecase.register()
                }
            case .primaryButton:
                break
            case nil:
                break
            }
        }
    }
}
