//
//  HomeView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/02.
//

import SwiftUI

struct HomeView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == HomeDataModel {
    @State var provider: Provider
    @State var searchUsecase: SearchUsecase
    @State var selectedVideo: VideoDataModel?

    @Environment(ToolbarManager.self) private var toolbarManager

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
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Image(systemName: "person")
                            }
                        }
                        .searchPresentationToolbarBehavior(.avoidHidingContent)
                        .searchable(text: $searchUsecase.searchText, placement: .automatic, prompt: "")
                        .onSubmit(of: .search) {
                            Task {
                                await searchUsecase.search()
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
            if let searchResults = dataModel.searchResults {
                List(searchResults, id: \.id) { video in
                    Text(video.title)
                }
            }

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
    }

    @ViewBuilder
    private func createCarouselView(using carousel: CarouselDataModel) -> some View {
        NavigationLink {
            GridContainerView(videos: carousel.videos)
        } label: {
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
                        NavigationLink {
                            VideoDetailView(video: video)
                        } label: {
                            CardView(video: video)
                        }
                        .modifier(CarouselButtonModifier())

                        Text(video.title)
                            .font(.title3)
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
//            if let image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFill()
//            } else {
//                Image(systemName: "wifi.slash")
//            }

            if let imageURL = video.thumbnail {
                AsyncImage(url: imageURL, content: { image in
                    image
                        .resizable()
                        .scaledToFill()

                }, placeholder: {
                    Image(systemName: "wifi.slash")
                })
            }

            LinearGradient(colors: [.clear, .clear, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom)
        }
//        .onAppear {
//            let headers = ["X-Plex-Token": PlexAuthentication.primaryTokenRuanPc]
//
//            // Create a custom URLSessionConfiguration
//            let config = URLSessionConfiguration.default
//            config.httpAdditionalHeaders = headers
//
//            // Create a custom URLSession with the configuration
//            let session = URLSession(configuration: config)
//
//            // Create a URLRequest with the custom session
//            if let imageUrl = video.thumbnail {
//                var request = URLRequest(url: imageUrl)
//                request.httpMethod = "GET"
//
//                // Load the image with the URLRequest
//                session.dataTask(with: request) { data, response, error in
//                    // Handle response if needed
//                    if let data {
//                        if let image = UIImage(data: data) {
//                            self.image = image
//                        } else {
//                            dump(data)
//                        }
//                    }
//                }
//                .resume()
//            }
//        }
    }
}

struct VideoDetailView: View {
    var video: VideoDataModel

    @State var presentVideoPlayer: Bool = false

    var body: some View {
        VStack {
            Button {
                presentVideoPlayer = true
            } label: {
                if let imageURL = video.thumbnail {
                    AsyncImage(url: imageURL, content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                    }, placeholder: {
                        Image(systemName: "wifi.slash")
                    })
                    .overlay {
                        LinearGradient(colors: [.black.opacity(1), .black.opacity(0.75), .black.opacity(0.5), .clear, .clear, .clear, .black.opacity(0.5), .black.opacity(0.75), .black.opacity(1)], startPoint: .top, endPoint: .bottom)
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.white.opacity(0.5))
                    }
                }
            }
            VStack {
                Text(video.description ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
            }
            .padding()
            Spacer()

        }
        .navigationTitle(video.title)
        .fullScreenCover(isPresented: $presentVideoPlayer) {
            createVideoPlayerView(with: video)
        }

    }

    @ViewBuilder
    private func createVideoPlayerView(with video: VideoDataModel) -> some View {
        if let url = video.url {
            VideoPlayer(playerController: AVPlayerController(link: url,
                                                             title: video.title,
                                                             publisher: video.id.uuidString,
                                                             thumbnail: video.thumbnail!))
            .ignoresSafeArea()
        } else {
            Image(systemName: "wifi.slash")
        }
    }
}

struct GridContainerView: View {
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
                    NavigationLink {
                        VideoDetailView(video: video)
                    } label: {
                        if let imageURL = video.thumbnail {
                            AsyncImage(url: imageURL, content: { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 110, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                            }, placeholder: {
                                Image(systemName: "wifi.slash")
                            })
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct ErrorDataModel: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let image: Image

    init(title: String, description: String, image: Image) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.image = image
    }
}

struct ErrorView: View {
    let errorModel: ErrorDataModel

    init(errorModel: ErrorDataModel) {
        self.errorModel = errorModel
    }

    var body: some View {
        VStack {
            Text(errorModel.title)
                .font(.title3)
                .padding()
            Text(errorModel.description)
                .font(.body)
            errorModel.image
                .font(.title3)
                .foregroundStyle(.red)
                .padding()
        }
    }
}
