import Foundation
import NeedleFoundation

protocol PlexDependency: Dependency {
    var username: String { get }
    var password: String { get }
}
