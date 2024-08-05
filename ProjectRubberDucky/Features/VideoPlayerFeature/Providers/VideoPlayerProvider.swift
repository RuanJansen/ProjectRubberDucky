import Foundation
import Combine

@Observable
class VideoPlayerProvider: FeatureProvider {
    public typealias DataModel = [VideoDataModel]

   public var viewState: ViewState<DataModel>
    
    private var cancelables: Set<AnyCancellable> = []

    private let repository: PlexRepository?

    init(repository: PlexRepository? = nil) {
        self.repository = repository
        self.viewState = .loading
    }

    public func fetchContent() async {
        await populateWithPlexStatic()
//        await populateWithPlex()
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
        let item1 = VideoDataModel(id: UUID(),
                                         title: "Jan Blomqvist",
                                         description: "Canopee Des Cimes Cercle Stories",
                                         url: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/parts/1/1720538684/file.mp4")!,
                                         thumbnail: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/metadata/1/thumb/1720538740")!,
                                         quality: "1080p")

        let item2 = VideoDataModel(id: UUID(),
                                         title: "Monolink",
                                         description: "Monolink live at Gaatafushi Island, in the Maldives for Cercle and W Hotels",
                                         url: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/parts/2/1720898073/file.mp4")!,
                                         thumbnail: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/metadata/2/thumb/1720898073")!,
                                         quality: "1440p")

        let item3 = VideoDataModel(id: UUID(),
                                         title: "WAVE WHITE (2021)",
                                         description: "Jan Blomqvist, Pink Lake, Ukraine",
                                         url: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/parts/3/1720898073/file.mp4")!,
                                         thumbnail: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/metadata/3/thumb/1720898073")!,
                                         quality: "1080p")


        let dataModel = [
            item1
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
