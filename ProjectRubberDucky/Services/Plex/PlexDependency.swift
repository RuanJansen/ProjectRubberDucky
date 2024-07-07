import Foundation
import NeedleFoundation

protocol PlexDependency: Dependency {
    var plexGateway: PlexGateway { get }
}
