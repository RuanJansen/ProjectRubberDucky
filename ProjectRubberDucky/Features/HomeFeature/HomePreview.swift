//import SwiftUI
//
//#Preview {
//    let mockProvider = MockHomeProvider()
//    return HomeView(provider: mockProvider, searchUsecase: SearchUsecase())
//}
//
//@Observable
//fileprivate class MockHomeProvider: FeatureProvider {
//    typealias DataModel = HomeDataModel
//
//    var viewState: ViewState<HomeDataModel>
//
//    init() {
//        self.viewState = .loading
//    }
//
//    func fetchContent() async {
//        self.viewState = .presentContent(using: HomeDataModel(pageTitle: "Home", topCarousel: [VideoDataModel(id: UUID(),
//                                                                                                              title: "Title",
//                                                                                                              description: "Description",
//                                                                                                              url: URL(string: "")!,
//                                                                                                              thumbnail: URL(string: "https://images.pexels.com/videos/3569327/free-video-356932")!,
//                                                                                                              quality: "1080p"),
//                                                                                               VideoDataModel(id: UUID(),
//                                                                                                              title: "Title",
//                                                                                                              description: "Description",
//                                                                                                              url: URL(string: "")!,
//                                                                                                              thumbnail: URL(string: "https://images.pexels.com/videos/3569327/free-video-356932")!,
//                                                                                                              quality: "1080p"),
//                                                                                               VideoDataModel(id: UUID(),
//                                                                                                              title: "Title",
//                                                                                                              description: "Description",
//                                                                                                              url: URL(string: "")!,
//                                                                                                              thumbnail: URL(string: "https://images.pexels.com/videos/3569327/free-video-356932")!,
//                                                                                                              quality: "1080p"),
//                                                                                               VideoDataModel(id: UUID(),
//                                                                                                              title: "Title",
//                                                                                                              description: "Description",
//                                                                                                              url: URL(string: "")!,
//                                                                                                              thumbnail: URL(string: "https://images.pexels.com/videos/3569327/free-video-356932")!,
//                                                                                                              quality: "1080p")], carousels: [
//CarouselDataModel(title: "title", videos: [
//    VideoDataModel(id: UUID(),
//                   title: "Title",
//                   description: "Description",
//                   url: URL(string: "")!,
//                   thumbnail: URL(string: "https://images.pexels.com/videos/3569327/free-video-356932")!,
//                   quality: "1080p"),
//    VideoDataModel(id: UUID(),
//                   title: "Title",
//                   description: "Description",
//                   url: URL(string: "")!,
//                   thumbnail: URL(string: "https://images.pexels.com/videos/3569327/free-video-356932")!,
//                   quality: "1080p"),
//    VideoDataModel(id: UUID(),
//                   title: "Title",
//                   description: "Description",
//                   url: URL(string: "")!,
//                   thumbnail: URL(string: "https://images.pexels.com/videos/3569327/free-video-356932")!,
//                   quality: "1080p"),
//    VideoDataModel(id: UUID(),
//                   title: "Title",
//                   description: "Description",
//                   url: URL(string: "")!,
//                   thumbnail: URL(string: "https://images.pexels.com/videos/3569327/free-video-356932")!,
//                   quality: "1080p")])
//                                                                                                              ]))
//    }
//
////    private func setupContent() -> [VideoDataModel] {
////        let item1 = VideoDataModel(id: UUID(),
////                                         title: "Jan Blomqvist",
////                                         description: "Canopee Des Cimes Cercle Stories",
////                                         url: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/parts/1/1720538684/file.mp4")!,
////                                         thumbnail: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/metadata/1/thumb/1720538740")!,
////                                         quality: "1080p")
////
////        let item2 = VideoDataModel(id: UUID(),
////                                         title: "Monolink",
////                                         description: "Monolink live at Gaatafushi Island, in the Maldives for Cercle and W Hotels",
////                                         url: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/parts/2/1720898073/file.mp4")!,
////                                         thumbnail: URL(string: "\(RuanMacbookAir.staticRemote.rawValue)/library/metadata/2/thumb/1720898073")!,
////                                         quality: "1440p")
////
////        let item3 = VideoDataModel(id: UUID(),
////                                         title: "Title",
////                                         description: "Description",
////                                         url: URL(string: "")!,
////                                         thumbnail: URL(string: "https://images.pexels.com/videos/3569327/free-video-356932")!,
////                                         quality: "1080p")
////
////
////        let dataModel = [
////            item1,
////            item2,
////            item3
////        ]
////
////        return dataModel
////    }
//}
