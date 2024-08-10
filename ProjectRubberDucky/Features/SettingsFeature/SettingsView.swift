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
                if let account = dataModel.account {
                    RDButton(action: account.action) {
                        HStack(spacing: 20) {
                            if let photoURL = account.imageURL {
                                KFImage(photoURL)
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 25)
                            }

                            if let title = account.title {
                                Text(title)
                            }
                        }
                        .padding(.vertical)
                    }
                    .foregroundStyle(.primary)
                }

                ForEach(dataModel.sections, id: \.id) { section in
                    Section {
                        ForEach(section.items, id: \.id) { item in
                            if let buttonAction = item.buttonAction {
                                RDButton(action: buttonAction, label: { Text(item.title) })
                                    .if(item.hasMaxWidth) { view in
                                        view
                                            .frame(maxWidth: .infinity)
                                    }
                                    .foregroundStyle(item.fontColor)
                            } else {
                                Text(item.title)
                                    .if(item.hasMaxWidth) { view in
                                        view
                                            .frame(maxWidth: .infinity)
                                    }
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

            if let build = dataModel.build {
                Text(build)
                    .font(.footnote)
                    .padding()
            }
        }
    }
}
