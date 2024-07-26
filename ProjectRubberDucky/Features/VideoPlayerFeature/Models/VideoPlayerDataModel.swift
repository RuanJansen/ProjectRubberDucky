import AVKit

struct VideoPlayerDataModel: Identifiable, Hashable {
    let id: UUID
    let title: String?
    let description: String?
    let url: URL?
    let thumbnail: URL?
    let quality: String?

    init(id: UUID = UUID(),
         title: String? = nil,
         description: String? = nil,
         url: URL? = nil,
         thumbnail: URL? = nil,
         quality: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.url = url
        self.thumbnail = thumbnail
        self.quality = quality
    }
}
