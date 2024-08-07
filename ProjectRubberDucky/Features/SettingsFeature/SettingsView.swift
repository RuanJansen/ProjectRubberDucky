//
//  SettingsView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct SettingsView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == SettingsDataModel {
    @State var provider: Provider

    init(provider: Provider) {
        self.provider = provider
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

            if let build = dataModel.build {
                Text(build)
                    .font(.footnote)
                    .padding()
            }
        }
    }
}
