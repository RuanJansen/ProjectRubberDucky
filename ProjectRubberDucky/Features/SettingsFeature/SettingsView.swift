//
//  SettingsView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

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
                ForEach(dataModel.sections, id: \.id) { section in
                    Section {
                        ForEach(section.items, id: \.id) { item in
                            NavigationLink {
                                ConstructionView()
                            } label: {
                                Text(item.title)
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

            Button {
                Task {
                    await logoutUsecase.LogOut()
                }
            } label: {
                Text("Log out")
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
