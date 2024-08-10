//
//  AccountView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import SwiftUI
import Kingfisher

struct AccountView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == AccountDataModel {
    @State var provider: Provider

    init(provider: Provider) {
        self._provider = State(wrappedValue: provider)
    }

    var body: some View {
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presentContent(let dataModel):
                createContentView(using: dataModel)
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
    private func createContentView(using dataModel: AccountDataModel) -> some View {
        VStack {
            if let user = dataModel.user {
                VStack(spacing: 20) {
                    if let photoURL = user.photoURL {
                        KFImage(photoURL)
                            .placeholder {
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    }

                    if let displayName = user.displayName {
                        Text(displayName)
                    }

                    if let email = user.email {
                        Text(email)
                    }
                }
            }

            Form {
                ForEach(dataModel.sections, id: \.id) { section in
                    Section {
                        ForEach(section.items, id: \.id) { item in
                            RDButton(action: item.buttonAction, label: { Text(item.title) })
                                .if(item.hasMaxWidth) { view in
                                    view
                                        .frame(maxWidth: .infinity)
                                }
                                .foregroundStyle(item.fontColor)
                        }
                    } header: {
                        if let header = section.header{
                            Text(header)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}
