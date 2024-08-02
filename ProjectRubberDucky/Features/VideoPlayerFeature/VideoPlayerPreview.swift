import SwiftUI

#Preview {
    let mockProvider = MockVideoPlayerProvider()
    return VideoPlayerView(provider: mockProvider,
                    searchUsecase: SearchUsecase())
    .environment(ToolbarManager())
}

@Observable
fileprivate class MockVideoPlayerProvider: FeatureProvider {
    typealias DataModel = [VideoPlayerDataModel]

    var viewState: ViewState<[VideoPlayerDataModel]>

    init() {
        self.viewState = .loading
    }

    func fetchContent() async {
        self.viewState = .presentContent(using: setupContent())
    }
    
    private func setupContent() -> [VideoPlayerDataModel] {
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

        return dataModel
    }

}
