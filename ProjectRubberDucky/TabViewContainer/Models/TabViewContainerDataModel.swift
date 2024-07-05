import NeedleFoundation
import SwiftUI

struct TabViewContainerDataModel: Tabable {
    public let id: UUID
    public let name: String
    public let systemImage: String
    public let feature: any Feature

    init(name: String, systemImage: String, feature: any Feature) {
        self.id = UUID()
        self.name = name
        self.systemImage = systemImage
        self.feature = feature
    }


    public static func == (lhs: TabViewContainerDataModel, rhs: TabViewContainerDataModel) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
