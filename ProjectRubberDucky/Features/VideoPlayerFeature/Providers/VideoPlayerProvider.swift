import Foundation
import Combine

class VideoPlayerProvider: FeatureProvider {
    public typealias DataModel = [VideoPlayerDataModel]

    @Published public var viewState: ViewState<DataModel>
    
    private var cancelables: Set<AnyCancellable> = []

    private let repository: PlexRepository?
    private let searchUsecase: SearchUsecase

    init(repository: PlexRepository? = nil,
         searchUsecase: SearchUsecase) {
        self.repository = repository
        self.searchUsecase = searchUsecase
        self.viewState = .loading
//        self.addSubscribers()
    }

    public func fetchContent() async {
//        await populateWithPexel()
        await populateWithPlexStatic()
//        await populateWithPlex()
    }

    private func addSubscribers() {
        searchUsecase.$searchActionHit.sink { isSearching in
            Task {
                await self.populateWithPexel(prompt: self.searchUsecase.searchText)
            }
        }
        .store(in: &cancelables)
    }

    private func populateWithPlex() async {
        if let repository {
            if let dataModel = await repository.fetch(key: "1") {
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
        let item1 = VideoPlayerDataModel(id: UUID(),
                                         title: "Jan Blomqvist",
                                         description: "Canopee Des Cimes Cercle Stories",
                                         url: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/parts/1/1720538684/file.mp4")!,
                                         thumbnail: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/metadata/1/thumb/1720538740")!,
                                         quality: "1080p")

        let item2 = VideoPlayerDataModel(id: UUID(),
                                         title: "Monolink",
                                         description: "Monolink live at Gaatafushi Island, in the Maldives for Cercle and W Hotels",
                                         url: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/parts/2/1720898073/file.mp4")!,
                                         thumbnail: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/metadata/2/thumb/1720898073")!,
                                         quality: "1440p")

        let item3 = VideoPlayerDataModel(id: UUID(),
                                         title: "WAVE WHITE (2021)",
                                         description: "Jan Blomqvist, Pink Lake, Ukraine",
                                         url: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/parts/3/1720898073/file.mp4")!,
                                         thumbnail: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/metadata/3/thumb/1720898073")!,
                                         quality: "1080p")


        let dataModel = [
            item1,
            item2,
            item3
        ]

        await MainActor.run {
            self.viewState = .presentContent(using: dataModel)
        }
    }

    private func populateWithPexel(prompt: String? = nil) async {
        let repository = PexelRepository()
           if let fetchedDataModel = await repository.fetchRemoteData(prompt: prompt) {
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
