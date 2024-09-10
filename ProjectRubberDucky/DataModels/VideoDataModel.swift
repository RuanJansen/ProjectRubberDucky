import AVKit

protocol CarouselItem: Identifiable {
    var id: UUID { get }
    var imageURL: URL { get }
}

struct VideoDataModel: CarouselItem, Hashable {
    var imageURL: URL {
        thumbnailImageUrl
    }

    let id: UUID
    let title: String
    let description: String?
    let category: String?
    let ageRating: String
    let videoFileUrl: URL
    let thumbnailImageUrl: URL
    let posterImageUrl: URL
    let squareImageUrl: URL
    let quality: String?

    init(id: UUID = UUID(),
         title: String,
         description: String? = nil,
         category: String? = nil,
         ageRating: String = "PG",
         url: URL,
         thumbnailImageUrl: URL,
         posterImageUrl: URL,
         squareImageUrl: URL,
         quality: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.ageRating = ageRating
        self.videoFileUrl = url
        self.thumbnailImageUrl = thumbnailImageUrl
        self.posterImageUrl = posterImageUrl
        self.squareImageUrl = squareImageUrl
        self.quality = quality
    }
}
