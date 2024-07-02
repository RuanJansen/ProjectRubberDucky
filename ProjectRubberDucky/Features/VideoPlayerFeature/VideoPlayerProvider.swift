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
//        await DependencyContainer.shared.rootComponent.plexComponent.plexRepository.fetch()

        if let repository,
           let fetchedDataModel = await repository.fetchRemoteData() {
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
