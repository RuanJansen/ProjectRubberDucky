import Foundation

class VideoPlayerProvider: FeatureProvider {
    public typealias DataModel = [VideoPlayerDataModel]

    @Published public var viewState: ViewState<DataModel>

    private let repository: VideoRepository?

    init(repository: VideoRepository? = nil) {
        self.repository = repository
        self.viewState = .loading
    }

    public func fetchContent() async {
        guard let url = URL(string: "https://172-29-6-20.6ff3f28836a64e218c04da392a2c3365.plex.direct:32400/library/parts/411860/1720283413/file.mp4") else { return }

        guard let thumbnail = URL(string: "https://172-29-6-20.6ff3f28836a64e218c04da392a2c3365.plex.direct:32400/library/metadata/387709/thumb/1720283539") else { return }

        let dataModel = [
            VideoPlayerDataModel(id: UUID(),
                                 title: "Jan Blomqvist (live) - Mayan Warrior - Burning Man 2019 (Official Video)",
                                 description: "2024",
                                 url: url,
                                 thumbnail: thumbnail,
                                 quality: nil)
        ]

        await MainActor.run {
            self.viewState = .presentContent(using: dataModel)
        }

//        if let repository,
//           let fetchedDataModel = await repository.fetchRemoteData() {
//            let dataModel = fetchedDataModel
//            await MainActor.run {
//                self.viewState = .presentContent(using: dataModel)
//            }
//        } else {
//            await MainActor.run {
//                self.viewState = .error
//            }
//        }
    }
}
