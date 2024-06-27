import Foundation
import SwiftUI
import AVKit

struct VideoPlayerView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == [VideoPlayerDataModel] {
    @StateObject var provider: Provider
    @State var isPresentingVideoPlayer = false
    @Environment(\.dismiss) private var dismiss

    init(provider: Provider) {
        self._provider = StateObject(wrappedValue: provider)
    }

    var body: some View {
        let _ = Self._printChanges()
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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(dataModel, id: \.id) { video in
                        Button {
                            isPresentingVideoPlayer = true
                        } label: {
                            AsyncImage(url: video.thumbnail) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Image(systemName: "wifi.slash")
                            }
                            .overlay {
                                LinearGradient(gradient: Gradient(colors: [.white.opacity(0), .white.opacity(0), .black]), startPoint: .top, endPoint: .bottom)
                                VStack {
                                    Spacer()
                                    HStack {
                                        Text(video.title ?? "Video title")
                                        Spacer()
                                        if let quality = video.quality {
                                            Text(quality.uppercased())
                                        }
                                    }
                                }
                                .foregroundColor(.white)
                                .padding()
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .frame(width: 200)
                        .fullScreenCover(isPresented: $isPresentingVideoPlayer, content: {
                            createVideoPlayerView(with: video)
                        })
                    }
                }
            }
            .navigationTitle("Video Player")
        }
    }

    @ViewBuilder
    private func createVideoPlayerView(with video: VideoPlayerDataModel) -> some View {
        VideoPlayer(playerController: PlayerController(link: video.url,
                                                       title: video.title!,
                                                       publisher: video.id.uuidString,
                                                       thumbnail: video.thumbnail!))
        .ignoresSafeArea()
    }
}
