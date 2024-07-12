import Foundation

class VideoPlayerProvider: FeatureProvider {
    public typealias DataModel = [VideoPlayerDataModel]

    @Published public var viewState: ViewState<DataModel>

    private let repository: PlexRepository?

    init(repository: PlexRepository? = nil) {
        self.repository = repository
        self.viewState = .loading
    }

    public func fetchContent() async {
        await populateWithPlexStatic()
//        await populateWithPlex()
//        await populateWithPexel()
    }

    private func populateWithPlex() async {
        if let repository {
            if let dataModel = await repository.fetch(key: "05") {
                await MainActor.run {
                    self.viewState = .presentContent(using: dataModel)
                }
            } else {
                await MainActor.run {
                    self.viewState = .none
                }
            }
        }
    }

    private func populateWithPlexStatic() async {
        guard let url = URL(string: "https://192.168.0.108:32400/library/parts/1/1720538684/file.mp4") else { return }

        guard let thumbnail = URL(string: "https://192.168.0.108:32400/library/metadata/1/thumb/1720538740") else { return }

        let dataModel = [
            VideoPlayerDataModel(id: UUID(),
                                 title: "Jan Blomqvist",
                                 description: "Canopee Des Cimes Cercle Stories",
                                 url: url,
                                 thumbnail: thumbnail,
                                 quality: nil)
        ]

        await MainActor.run {
            self.viewState = .presentContent(using: dataModel)
        }
    }

    private func populateWithPexel() async {
        let repository = VideoRepository()
           if let fetchedDataModel = await repository.fetchRemoteData() {
            let dataModel = fetchedDataModel
            await MainActor.run {
                self.viewState = .presentContent(using: dataModel)
            }
        } else {
            await MainActor.run {
                self.viewState = .error
            }
        }
    }
}
