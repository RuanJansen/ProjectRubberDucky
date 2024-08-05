import Foundation
import SwiftUI
import AVKit

struct VideoPlayerView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == [VideoDataModel] {
    @State var provider: Provider
    @State var selectedVideo: VideoDataModel?

    init(provider: Provider) {
        self.provider = provider
    }

    var body: some View {
        VStack {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presentContent(let dataModel):
                NavigationStack {
                    createContentView(using: dataModel)
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
    private func createContentView(using dataModel: [VideoDataModel]) -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                createCarouselView(using: dataModel)
                Spacer()
            }
        }
    }

    @ViewBuilder
    private func createCarouselView(using dataModel: [VideoDataModel]) -> some View {
        NavigationLink {
            EmptyView()
        } label: {
            Text("Plex Content")
                .font(.title3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.horizontal)
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
                            .font(.title3)
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
    }
#endif

#if os(tvOS)
    @ViewBuilder
    private func createContentView(using dataModel: [VideoDataModel]) -> some View {
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

