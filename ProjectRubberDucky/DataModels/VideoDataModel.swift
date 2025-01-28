import AVKit

struct VideoDataModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String?
    let genre: String?
    let rated: String?
    let quality: String?
    let runtime: String?
    let videoFileUrl: URL
    let thumbnailImageUrl: URL
    let posterImageUrl: URL
    let squareImageUrl: URL

    init(id: UUID,
         title: String,
         description: String? = nil,
         genre: String? = nil,
         rated: String?  = nil,
         quality: String? = nil,
         runtime: String? = nil,
         videoFileUrl: URL,
         thumbnailImageUrl: URL,
         posterImageUrl: URL? = nil,
         squareImageUrl: URL? = nil) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.genre = genre
        self.rated = rated
        self.quality = quality
        self.runtime = runtime
        self.videoFileUrl = videoFileUrl
        self.thumbnailImageUrl = thumbnailImageUrl
        self.posterImageUrl = posterImageUrl ?? thumbnailImageUrl
        self.squareImageUrl = squareImageUrl ?? thumbnailImageUrl
    }
}
