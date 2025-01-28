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
    @Environment(AppStyling.self) var appStyling

    init(provider: Provider) {
        self.provider = provider
    }

    var body: some View {
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presenting(let dataModel):
                NavigationStack {
                    createContentView(using: dataModel)
                        .ignoresSafeArea(edges: .top)
                        .refreshable {
                            await provider.fetchContent()
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
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if let featuredVideos = dataModel.featuredVideos {
                            createFeaturedCarouselView(using: featuredVideos)
                        }

                        ForEach(carousels, id: \.id) { carousel in
                            createCarouselView(using: carousel)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    @ViewBuilder
    private func createFeaturedCarouselView(using carouselVideos: [VideoDataModel]) -> some View {
        VStack {
            TabView {
                ForEach(carouselVideos, id: \.id) { video in
                    VStack {
                        RDButton(.navigate(hideChevron: true) {
                            AnyView(VideoDetailView(video: video))
                        }) {
                            KFImage(video.thumbnailImageUrl)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .overlay {
                                    LinearGradient(colors: [.clear,
                                                            .clear,
                                                            .clear,
                                                            .clear,
                                                            .clear,
                                                            .black.opacity(0.25),
                                                            .black.opacity(0.5),
                                                            .black.opacity(0.75),
                                                            .black],
                                                   startPoint: .top,
                                                   endPoint: .bottom)
                                }
                                .overlay(alignment: .bottom) {
                                    VStack(alignment: .center) {
                                        Text(video.title.capitalized)
                                            .font(.system(size: 24, weight: .bold))
                                        if let genre = video.genre {
                                            HStack(alignment: .bottom) {
                                                Text(genre.capitalized)
                                                if let rated = video.rated {
                                                    Text(" • \(rated)")
                                                }
                                            }
                                            .font(.system(size: 17, weight: .medium))
                                        }
                                    }
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)
                                }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .frame(height: 275)
    }

    @ViewBuilder
    private func createCarouselView(using carousel: CarouselDataModel) -> some View {
        RDButton(.navigate(hideChevron: true) {
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
                        RDButton(.navigate(hideChevron: true) {
                            AnyView(VideoDetailView(video: video))
                        }) {
                            VideoCardTeplate(video: video)
                        }
                        .modifier(CarouselButtonModifier())
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

struct VideoCardTeplate: View {
    private let video: VideoDataModel

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
            KFImage(video.thumbnailImageUrl)
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
                    KFImage(video.thumbnailImageUrl)
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

//                HStack {
//                    RDButton(.fullScreenCover(swipeDismissable: true) {
//                        AnyView(createVideoPlayerView(with: video))
//                    }) {
//                        Label("Watch Trailer", systemImage: "popcorn.fill")
//                    }
//                    Spacer()
//                }
//                .padding(.horizontal)

                VStack {
                    if let description = video.description {
                        Text(description)
                    }
                }
                .padding()
                Spacer()
            }

        }
        .navigationTitle(video.title)
    }

    @ViewBuilder
    private func createVideoPlayerView(with video: VideoDataModel) -> some View {
        let player = AVPlayerController(videoFileURL: video.videoFileUrl)
        VideoPlayer(playerController: player)
            .onDisappear {
                player.teardownPlayer()
            }
            .ignoresSafeArea()
    }
}

struct GridContainerView: View {
    var title: String
    var videos: [VideoDataModel]

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(videos, id: \.id) { video in
                    VStack {
                        RDButton(.navigate(hideChevron: true) {
                            AnyView(VideoDetailView(video: video))
                        }) {
                            KFImage(video.thumbnailImageUrl)
                                .placeholder {
                                    Image(systemName: "wifi.slash")
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 175, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(alignment: .bottomTrailing) {
                                    if let quality = video.quality {
                                        Text(quality.uppercased())
                                            .font(.callout)
                                            .foregroundStyle(.white)
                                            .padding(5)
                                    }
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

