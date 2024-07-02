import NeedleFoundation

extension RootComponent {
    public var plexComponent: PlexComponent {
        PlexComponent(parent: self)
    }

    public var username: String {
        PlexAuthentication.ruan.username
    }

    public var password: String {
        PlexAuthentication.ruan.password
    }

    public var token: String {
        PlexAuthentication.primaryToken
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
