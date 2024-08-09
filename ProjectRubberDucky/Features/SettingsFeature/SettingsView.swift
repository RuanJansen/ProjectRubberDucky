//
//  SettingsView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI
import Kingfisher

struct SettingsView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == SettingsDataModel {
    @State var provider: Provider
    @State var logoutUsecase: LogoutUsecase

    init(provider: Provider,
         logoutUsecase: LogoutUsecase) {
        self._provider = State(wrappedValue: provider)
        self._logoutUsecase = State(wrappedValue: logoutUsecase)
    }

    var body: some View {
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presentContent(let dataModel):
                NavigationStack {
                    createContentView(using: dataModel)
                        .navigationTitle("Settings")
                }
            case .error:
                EmptyView()
            case .none:
                ConstructionView()
            }
        }
        .task {
            await provider.fetchContent()
        }
    }

    @ViewBuilder
    private func createContentView(using dataModel: SettingsDataModel) -> some View {
        VStack {
            Form {
                if let user = dataModel.user {
                    HStack(spacing: 20) {
                        if let photoURL = user.photoURL {
                            KFImage(photoURL)
                                .placeholder {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                        }

                        if let displayName = user.displayName {
                            Text(displayName)
                        } else if let email = user.email {
                            Text(email)
                        } else {
                            Text("User")
                        }
                    }
                }


                ForEach(dataModel.sections, id: \.id) { section in
                    Section {
                        ForEach(section.items, id: \.id) { item in
                            if let buttonAction = item.buttonAction {
                                RDButton(action: buttonAction, label: { Text(item.title) })
                                    .foregroundStyle(item.fontColor)
                            } else {
                                Text(item.title)
                                    .foregroundStyle(item.fontColor)
                            }
                        }
                    } header: {
                        if let header = section.header{
                            Text(header)
                        }

                    }
                }
            }

            Spacer()

            RDButton(action: dataModel.logOut.action) {
                Text(dataModel.logOut.title)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.primary)
                    .font(.title2)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                    }
            }
            .tint(.red)
            .padding(.horizontal)

            if let build = dataModel.build {
                Text(build)
                    .font(.footnote)
                    .padding()
            }
        }
    }
}
