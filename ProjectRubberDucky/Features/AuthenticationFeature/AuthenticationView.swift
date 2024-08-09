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
                        .ignoresSafeArea(.keyboard)
                        .if(authenticationUsecase.showingIsLoadingToast) { view in
                            view.overlay {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial))
                            }
                        }
                        .alert(authenticationUsecase.fetchInvalidEmailRDAlertModel().title,
                               isPresented: $authenticationUsecase.showingInvalidEmail, actions: {
                            ForEach(authenticationUsecase.fetchInvalidEmailRDAlertModel().buttons, id: \.id) { button in
                                    Button(role: button.role) {
                                        button.action()
                                    } label: {
                                        Text(button.title)
                                    }
                                }
                        }, message: {
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
                    TextField(dataModel.signIn.sectionHeader1, text: $authenticationUsecase.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text(dataModel.signIn.sectionHeader1)
                }

                Section {
                    SecureField(dataModel.signIn.sectionHeader2, text: $authenticationUsecase.password)
                } header: {
                    Text(dataModel.signIn.sectionHeader2)
                }
            }
            .frame(maxHeight: 200)
            .scrollDisabled(true)
            .padding(.bottom)

            Button {
                Task {
                    await authenticationUsecase.signIn()
                }
            } label: {
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
            }
            .padding(.horizontal)
            .padding(.bottom)

            NavigationLink {
                createRegstraterView(dataModel: dataModel.register)
            } label: {
                Text(dataModel.signIn.secondaryAction)
            }
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
    }

    @ViewBuilder
    private func createRegstraterView(dataModel: AuthenticationRegisterDataModel) -> some View {
        VStack {
            Form {
                Section {
                    TextField(dataModel.sectionHeader1, text: $authenticationUsecase.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text(dataModel.sectionHeader1)
                }

                Section {
                    SecureField(dataModel.sectionHeader2, text: $authenticationUsecase.password)
                } header: {
                    Text(dataModel.sectionHeader2)
                }

//                Section {
//                    SecureField("Password", text: $authenticationUsecase.password)
//                } header: {
//                    Text("Re-enter password")
//                }

//                Section {
//                    TextField("Username", text: $authenticationUsecase.username)
//                        .autocorrectionDisabled()
//                        .textInputAutocapitalization(.never)
//                } header: {
//                    Text("About you")
//                }

            }
            .padding(.bottom)

            Button {
                Task {
                    await authenticationUsecase.register()
                }
            } label: {
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
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle(dataModel.pageTitle)
    }
}
