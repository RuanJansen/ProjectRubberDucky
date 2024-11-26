//
//  LibraryView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct LibraryView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == LibraryDataModel {
    @State var provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    var body: some View {
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presenting(let using):
                EmptyView()
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
}
