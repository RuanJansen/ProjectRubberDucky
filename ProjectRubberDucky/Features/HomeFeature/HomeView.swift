//
//  HomeView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/02.
//

import SwiftUI
import Kingfisher

struct HomeView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == HomeDataModel {
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
            case .presentContent(let dataModel):
                NavigationStack {
                    createContentView(using: dataModel)
                        .navigationTitle("Home")
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
                ErrorView(errorModel: ErrorDataModel(title: "Whoops!",
                                                     description: "It looks like we ran into an issue...",
                                                     image: Image(systemName: "exclamationmark.circle.fill")))
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
    private func createContentView(using dataModel: HomeDataModel) -> some View {
        VStack {
            if let carousels = dataModel.carousels {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        ForEach(carousels, id: \.id) { carousel in
                            createCarouselView(using: carousel)
                        }
                        Spacer()
                    }
                }
            }
        }
        .overlay {
            if let searchResults = dataModel.searchResults {
                List(searchResults, id: \.id) { video in
                    RDButton(.navigate({
                        AnyView(VideoDetailView(video: video))
                    })) {
                        Text(video.title)
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }

    @ViewBuilder
    private func createCarouselView(using carousel: CarouselDataModel) -> some View {

        RDButton(.navigate(hideCevron: true) {
            AnyView(GridContainerView(title: carousel.title, videos: carousel.videos))
        }) {
            Label(carousel.title, systemImage: "chevron.right")
                .environment(\.layoutDirection, .rightToLeft)
                .font(.title3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.horizontal)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(carousel.videos, id: \.id) { video in
                    VStack {
                        RDButton(.navigate(hideCevron: true) {
                            AnyView(VideoDetailView(video: video))
                        }) {
                            CardView(video: video)
                        }
                        .modifier(CarouselButtonModifier())

                        Text(video.title)
                            .font(.subheadline)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
#endif

    @ViewBuilder
    private func createBackgroundView() -> some View {
        ZStack {
            Circle()
                .fill(.purple)
                .blur(radius: 120.0)
                .frame(width: 750)
                .offset(x: -500, y: -100)

            Circle()
                .fill(.cyan)
                .blur(radius: 120.0)
                .frame(width: 750)
                .offset(x: 500, y: 100)

            Circle()
                .fill(.purple)
                .blur(radius: 120.0)
                .frame(width: 250)
                .offset(x: 750, y: -600)
        }
    }
}

struct CardView: View {
    private let video: VideoDataModel
    @State private var image: UIImage?
    init(video: VideoDataModel) {
        self.video = video
    }

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Spacer()
                if let quality = video.quality {
                    Text(quality.uppercased())
                        .font(.callout)
                }
            }
        }
        .padding()
        .background {
            KFImage(video.thumbnail)
                .placeholder {
                    Image(systemName: "wifi.slash")

                }
                .resizable()
                .scaledToFill()


            LinearGradient(colors: [.clear, .clear, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom)
        }
    }
}

struct VideoDetailView: View {
    var video: VideoDataModel
    var body: some View {
        VStack {
            ScrollView {
                RDButton(.fullScreenCover(swipeDismissable: true) {
                    AnyView(createVideoPlayerView(with: video))
                }) {
                    KFImage(video.thumbnail)
                        .placeholder {
                            Image(systemName: "wifi.slash")

                        }
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .overlay {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color.white.opacity(0.5))
                        }

                }
                .padding(.horizontal)

                HStack {
                    RDButton(.fullScreenCover(swipeDismissable: true) {
                        AnyView(createVideoPlayerView(with: video))
                    }) {
                        Label("Watch Trailer", systemImage: "popcorn.fill")
                    }
                    Spacer()
                }
                .padding(.horizontal)

                VStack {
                    Text(video.description ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                }
                .padding()
                Spacer()
            }

        }
        .navigationTitle(video.title)
    }

    @ViewBuilder
    private func createVideoPlayerView(with video: VideoDataModel) -> some View {
        VideoPlayer(playerController: AVPlayerController(link: video.url,
                                                         title: video.title,
                                                         publisher: video.id.uuidString,
                                                         thumbnail: video.thumbnail))
        .ignoresSafeArea()
    }

}

struct GridContainerView: View {
    var title: String
    var videos: [VideoDataModel]

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(videos, id: \.id) { video in
                    VStack {
                        NavigationLink {
                            VideoDetailView(video: video)
                        } label: {
                            KFImage(video.thumbnail)
                                .placeholder {
                                    Image(systemName: "wifi.slash")

                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                        }
                        .overlay {
                            VStack(alignment: .leading) {
                                Spacer()
                                HStack {
                                    Text(video.title)
                                        .multilineTextAlignment(.leading)
                                        .font(.footnote)
                                    Spacer()
                                }
                                .frame(height: 55)
                                .padding(.horizontal)
                                .background(.ultraThinMaterial)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        Spacer()
                    }
                }
            }
            .padding()
        }
        .navigationTitle(title)
    }
}

