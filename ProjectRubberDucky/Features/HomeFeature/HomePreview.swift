import SwiftUI

#Preview {
    let mockProvider = MockHomeProvider()
    return HomeView(provider: mockProvider, searchUsecase: SearchUsecase(provider: mockProvider))
}

@Observable
fileprivate class MockHomeProvider: FeatureProvider, SearchableProvider {
    func clearSearch() async {
        self.viewState = .presentContent(using: HomeDataModel(carousels: [CarouselDataModel(title: "Music", videos: setupContent())]))
    }
    
    typealias DataModel = HomeDataModel

    var viewState: ViewState<HomeDataModel>

    init() {
        self.viewState = .loading
    }

    func fetchContent() async {
        self.viewState = .presentContent(using: HomeDataModel(carousels: [CarouselDataModel(title: "Music", videos: setupContent())]))
    }

    private func setupContent() -> [VideoDataModel] {
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
            item1,
            item2,
            item3
        ]

        return dataModel
    }

    func searchContent(prompt: String) async {
        self.viewState = .presentContent(using: HomeDataModel(searchResults: setupContent()))
    }

}
