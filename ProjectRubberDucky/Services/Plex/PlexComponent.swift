import NeedleFoundation

extension RootComponent {
    public var plexComponent: PlexComponent {
        PlexComponent(parent: self)
    }

    public var username: String {
        "darthjansen@gmail.com"
    }

    public var password: String {
        "Ruan0209"
    }
}

class PlexComponent: Component<PlexDependency> {
    private var plexCaller: PlexCaller {
        PlexCaller(username: dependency.username,
                   password: dependency.password)
    }

    public var plexRepository: PlexRepository {
        PlexRepository(plexCaller: plexCaller)
    }
}
