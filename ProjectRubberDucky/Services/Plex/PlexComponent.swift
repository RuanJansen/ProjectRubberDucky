import NeedleFoundation

extension RootComponent {
    public var plexComponent: PlexComponent {
        PlexComponent(parent: self)
    }

    public var plexGateway: PlexGateway {
        PlexGateway()
    }
}

class PlexComponent: Component<PlexDependency> {
    public var plexRepository: PlexRepository {
        PlexRepository(plexContent: dependency.plexGateway)
    }
}
