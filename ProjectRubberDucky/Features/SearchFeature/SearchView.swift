//
//  SearchView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/09/10.
//

import SwiftUI

struct SearchView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == SearchDataModel {
    @State var provider: Provider
    @Bindable var searchUsecase: SearchUsecase

    @Environment(AppStyling.self) var appStyling

    init(provider: Provider,
         searchUsecase: SearchUsecase) {
        self.provider = provider
        self.searchUsecase = searchUsecase

    }

    var body: some View {
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presenting(let dataModel):
                NavigationStack {
                    createContentView(using: dataModel)
                        .navigationTitle(dataModel.pageTitle)
                        .searchPresentationToolbarBehavior(.avoidHidingContent)
                        .searchable(text: $searchUsecase.searchText, placement: .automatic, prompt: "")
                        .onSubmit(of: .search) {
                            Task {
                                await searchUsecase.search()
                            }
                        }
                        .onChange(of: searchUsecase.searchText) {
                            Task {
                                await searchUsecase.clearSearch()
                            }
                        }
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


#if os(iOS)
    @ViewBuilder
    private func createContentView(using dataModel: SearchDataModel) -> some View {
        VStack {
            EmptyView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            if let searchResults = searchUsecase.searchVideos {
                List(searchResults, id: \.id) { video in
                    RDButton(.navigate({
                        AnyView(VideoDetailView(video: video))
                    })) {
                        Text(video.title)
                    }
                    .foregroundStyle(.primary)
                }
                .listStyle(.inset)
            }
        }
    }
#endif
}

