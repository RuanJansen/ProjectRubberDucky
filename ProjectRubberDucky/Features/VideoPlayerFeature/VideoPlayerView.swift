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
                            CardView(item: video)
                        }
                        .modifier(CarouselButtonModifier())

                        Text(video.title)
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

    @ViewBuilder
    private func createVideoPlayerView(with video: VideoDataModel) -> some View {
            VideoPlayer(playerController: AVPlayerController(link: video.videoFileUrl,
                                                             title: video.title,
                                                             publisher: video.id.uuidString,
                                                             thumbnail: video.thumbnailImageUrl))
            .ignoresSafeArea()
    }
}

