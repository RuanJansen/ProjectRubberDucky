//
//  AccountView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import SwiftUI

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
                setupContentView(with: dataModel)
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
    private func setupContentView(with dataModel: AccountDataModel) -> some View {
        VStack {
            Spacer()
            RDButton(action: dataModel.deleteAccountSection.buttonAction) {
                Text(dataModel.deleteAccountSection.title)
                    .padding(.vertical, 8)
                    .foregroundStyle(dataModel.deleteAccountSection.fontColor)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.primary)
                    .font(.title2)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                    }
            }
            .tint(.red)
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}
