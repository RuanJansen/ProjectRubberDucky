import AVKit

struct VideoDataModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String?
    let category: String?
    let url: URL
    let thumbnail: URL
    let quality: String?

    init(id: UUID = UUID(),
         title: String,
         description: String? = nil,
         category: String? = nil,
         url: URL,
         thumbnail: URL,
         quality: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.url = url
        self.thumbnail = thumbnail
        self.quality = quality
    }
}
