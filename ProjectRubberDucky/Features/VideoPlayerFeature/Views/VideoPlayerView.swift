import Foundation
import SwiftUI
import AVKit

struct VideoPlayerView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == [VideoPlayerDataModel] {
    @StateObject var provider: Provider
    @State var isPresentingVideoPlayer = false
    @State var selectedVideo: VideoPlayerDataModel? = nil
    @Environment(\.dismiss) private var dismiss

    init(provider: Provider) {
        self._provider = StateObject(wrappedValue: provider)
    }

    var body: some View {
        VStack {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presentContent(let dataModel):
                createContentView(using: dataModel)
            case .error:
                ProgressView()
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
    private func createContentView(using dataModel: [VideoPlayerDataModel]) -> some View {
        NavigationStack {
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
                            .padding()
                            .foregroundColor(.white)
                        }
                        .background {
                            AsyncImage(url: video.thumbnail) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "wifi.slash")
                            }
                            LinearGradient(colors: [.black, .clear, .black], startPoint: .top, endPoint: .bottom)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .frame(width: 350, height: 175)
                        .fullScreenCover(item: $selectedVideo) { video in
                            createVideoPlayerView(with: video)
                        }
                    }
                }
            }
            .navigationTitle("Video Player")
        }
    }
#endif

#if os(tvOS)
    @ViewBuilder
    private func createContentView(using dataModel: [VideoPlayerDataModel]) -> some View {
        NavigationStack {
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
                                .foregroundColor(.primary)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .frame(width: 350, height: 175)
                            .fullScreenCover(item: $selectedVideo) { video in
                                createVideoPlayerView(with: video)
                            }
                        }
                    }
                }
                Spacer()
                HStack {
                    createVideoDetailView()
                }
            }
            .background() {
                createBackgroundView()
            }
            .navigationTitle("Video Player")
        }
    }

    @ViewBuilder
    private func createVideoDetailView() -> some View {
        if let selectedVideo {
            AsyncImage(url: selectedVideo.thumbnail) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
            } placeholder: {
                Image(systemName: "wifi.slash")
            }

            VStack(alignment: .leading) {
                Text((selectedVideo.title)!)
                    .font(.title)
                Text((selectedVideo.quality?.uppercased())!)
                Spacer()
            }
        }
    }
#endif

    @ViewBuilder
    private func createBackgroundView() -> some View {
        ZStack {
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
        VideoPlayer(playerController: AVPlayerController(link: video.url,
                                                       title: video.title!,
                                                       publisher: video.id.uuidString,
                                                       thumbnail: video.thumbnail!))
        .ignoresSafeArea()
    }
}
