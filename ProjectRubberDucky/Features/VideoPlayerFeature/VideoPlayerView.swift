import Foundation
import SwiftUI
import AVKit

struct VideoPlayerView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == [VideoPlayerDataModel] {
    @StateObject var provider: Provider
    @State var avPlayer: AVPlayer = AVPlayer()

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

    @ViewBuilder
    private func createContentView(using dataModel: [VideoPlayerDataModel]) -> some View {
        NavigationStack {
            VStack {
                List(dataModel, id: \.id) { video in
                    NavigationLink(value: video) {
                        HStack {
                            AsyncImage(url: video.thumbnail) { image in
                                image
                                    .resizable()
                                    .frame(width: 50)
                                    .scaledToFit()
                            } placeholder: {
                                Image(systemName: "wifi.slash")
                            }
                            Text(video.title)
                            Spacer()
                        }
                    }
                    .navigationDestination(for: VideoPlayerDataModel.self) { video in
                        createVideoPlayerView(for: video)
                    }
                }
            }
            .navigationTitle("Video Player")
        }
    }

    @ViewBuilder
    private func createVideoPlayerView(for video: VideoPlayerDataModel) -> some View {
        VideoPlayer(player: avPlayer)
            .ignoresSafeArea()
            .onAppear {
                avPlayer = AVPlayer(url: video.url)
                avPlayer.play()
            }
    }
}
