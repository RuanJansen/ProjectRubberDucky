//
//  SubscribedView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct SubscribedView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == SubscribedDataModel {
    @State var provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    var body: some View {
        switch provider.viewState {
        case .loading:
            ProgressView()
        case .presentContent(let using):
            EmptyView()
        case .error:
            EmptyView()
        case .none:
            EmptyView()
        }
    }
}
