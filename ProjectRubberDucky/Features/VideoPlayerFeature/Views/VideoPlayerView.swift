import Foundation
import SwiftUI
import AVKit

struct VideoPlayerView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == [VideoPlayerDataModel] {
    @StateObject var provider: Provider
    @StateObject var searchUsecase: SearchUsecase
    @State var selectedVideo: VideoPlayerDataModel?

    init(provider: Provider,
         searchUsecase: SearchUsecase) {
        self._provider = StateObject(wrappedValue: provider)
        self._searchUsecase = StateObject(wrappedValue: searchUsecase)
    }

    var body: some View {
        VStack {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presentContent(let dataModel):
                NavigationStack {
                    createContentView(using: dataModel)
                        .searchable(text: $searchUsecase.searchText, placement: .automatic, prompt: "")
                        .onSubmit(of: .search) {
                            searchUsecase.search()
                        }
                }
            case .error:
                ProgressView()
            case .none:
                Button {
                    Task {
                        await provider.fetchContent()
                    }
                } label: {
                    Text("Reload")
                }
            }
        }
        .task {
            await provider.fetchContent()
        }
    }

#if os(iOS)
    @ViewBuilder
    private func createContentView(using dataModel: [VideoPlayerDataModel]) -> some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(dataModel, id: \.id) { video in
                        VStack {
                            Button {
                                selectedVideo = video
                            } label: {
                                CardView(video: video)
                            }
                            .modifier(CarouselButtonModifier())

                            Text(video.title ?? "Video title")
                                .font(.title2)
                        }
                        .fullScreenCover(item: $selectedVideo) { video in
                            createVideoPlayerView(with: video)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            Spacer()
        }
    }
#endif

#if os(tvOS)
    @ViewBuilder
    private func createContentView(using dataModel: [VideoPlayerDataModel]) -> some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(dataModel, id: \.id) { video in
                        Button {
                            selectedVideo = video
                        } label: {
                            VStack(alignment: .leading) {
                                Text(video.title ?? "Video title")
                                Spacer()
                                HStack {
                                    Spacer()
                                    if let quality = video.quality {
                                        Text(quality.uppercased())
                                    }
                                }
                            }
                        }
                        .modifier(CarouselButtonModifier())
                        .fullScreenCover(item: $selectedVideo) { video in
                            createVideoPlayerView(with: video)
                        }
                    }
                }
            }
            Spacer()
//            HStack {
//                createVideoDetailView()
//            }
        }
    }

//    @ViewBuilder
//    private func createVideoDetailView() -> some View {
//        if let focusVideo {
//            AsyncImage(url: focusVideo.thumbnail) { image in
//                image
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
//            } placeholder: {
//                Image(systemName: "wifi.slash")
//            }
//
//            VStack(alignment: .leading) {
//                Text((focusVideo.title)!)
//                    .font(.title)
//                Text((focusVideo.quality?.uppercased())!)
//                Spacer()
//            }
//        }
//    }
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

    @ViewBuilder
    private func createVideoPlayerView(with video: VideoPlayerDataModel) -> some View {
        if let url = video.url {
            VideoPlayer(playerController: AVPlayerController(link: url,
                                                             title: video.title!,
                                                             publisher: video.id.uuidString,
                                                             thumbnail: video.thumbnail!))
            .ignoresSafeArea()
        } else {
            Image(systemName: "wifi.slash")
        }
    }
}

struct CardView: View {
    private let video: VideoPlayerDataModel
    @State private var image: UIImage?
    init(video: VideoPlayerDataModel) {
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
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()

//                Image(url: video.thumbnail,
//                      headers: ["X-Plex-Token": PlexAuthentication.primaryToken],
//                      placeholderImage: Image(systemName: "wifi.slash"))
            } else {
                Image(systemName: "wifi.slash")
            }
            LinearGradient(colors: [.clear, .clear, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom)
        }
        .onAppear {
            let headers = ["X-Plex-Token": PlexAuthentication.primaryTokenRuanPc]

            // Create a custom URLSessionConfiguration
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = headers
            
            // Create a custom URLSession with the configuration
            let session = URLSession(configuration: config)

            // Create a URLRequest with the custom session
            if let imageUrl = video.thumbnail {
                var request = URLRequest(url: imageUrl)
                request.httpMethod = "GET"

                // Load the image with the URLRequest
                session.dataTask(with: request) { data, response, error in
                    // Handle response if needed
                    if let data {
                        if let image = UIImage(data: data) {
                            self.image = image
                        } else {
                            dump(data)
                        }
                    }
                }
                .resume()
            }
        }
    }
}
