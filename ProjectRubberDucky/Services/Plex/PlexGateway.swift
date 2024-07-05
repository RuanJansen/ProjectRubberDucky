import Foundation
import PlexKit
import Combine

struct PlexAuthentication {
    static let ruan = (username: "darthjansen@gmail.com", 
                       password: "Ruan0209")
    static let rikus = (username: "rikus102@gmail.com",
                        password: "Acid3471")
    static let primaryToken = "-szo-akRdn4CDHkY3VpJ"
}

class PlexGateway {
    private let client = Plex(sessionConfiguration: .default, 
                              clientInfo: Plex.ClientInfo(clientIdentifier: UUID().uuidString))

    private let username: String
    private let password: String

    @Published private var user: PlexUser?
    @Published private var servers: [PlexResource]?

    private var url: URL?

    var cancelables: Set<AnyCancellable>

    init(username: String, password: String) {
        self.username = username
        self.password = password
        self.cancelables = Set<AnyCancellable>()
        authenticateUser()
    }

    private func addSubscribers() {
        $user.sink { user in
            self.populateServers()
        }
        .store(in: &cancelables)

        $servers.sink { servers in
            self.setUrl()
        }
        .store(in: &cancelables)
    }

    private func authenticateUser() {
        client.request(
            Plex.ServiceRequest.SimpleAuthentication(
                username: username,
                password: password
            )
        ) { result in
            switch result {
            case .success(let response):
                self.user = response.user
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }
    }

    private func populateServers() {
        client.request(
            Plex.ServiceRequest.Resources(),
            token: user?.authenticationToken
        ) { result in
            switch result {
            case .success(let response):
                let servers = response.filter { $0.capabilities.contains(.server)}
                self.servers = servers
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }

    }

    private func setUrl() {
        guard let uri = servers?.first?.connections.first?.uri else { return }
        url = URL(string: uri)
    }

    func fetchLibraries(completion: @escaping ([PlexLibrary]?)->()) {
        var libraries: [PlexLibrary]?
        guard let url else { return }
        client.request(
            Plex.Request.Libraries(),
            from: url,
            token: PlexAuthentication.primaryToken
        ) { result in
            switch result {
            case .success(let response):
                libraries = response.mediaContainer.directory
                completion(libraries)
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }
    }

    func fetch(_ mediaType: PlexMediaType, for key: String) -> Plex.Request.Collections.Response? {
        var collectionsResponse: Plex.Request.Collections.Response?
        guard let url else { return nil }
        client.request(Plex.Request.Collections(libraryKey: key, mediaType: mediaType),
                       from: url,
                       token: PlexAuthentication.primaryToken) { result in
            switch result {
            case .success(let response):
                collectionsResponse = response
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }
        return collectionsResponse
    }

}

extension PlexGateway {

//    func fetch(_ url: String) -> URL? {
//        guard let safeUrl = URL(string: url) else { return nil }
//        client.request(Plex.Request.Image(path: url),
//                       from: safeUrl,
//                       token: PlexAuthentication.primaryToken) { result in
//            switch result {
//            case .success(let response):
//                response.self
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
}

extension PlexGateway {
    private func fetchAuthenticatedUserDetails(username: String, password: String, completion: @escaping (Plex.ServiceRequest.SimpleAuthentication.Response?)->()) {
        client.request(
            Plex.ServiceRequest.SimpleAuthentication(
                username: username,
                password: password
            )
        ) { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }
    }

    private func findPlexResources(with token: String, completion: @escaping ([PlexResource]?)->()) {
        client.request(
            Plex.ServiceRequest.Resources(),
            token: token
        ) { result in
            switch result {
            case .success(let response):
                let servers = response.filter { $0.capabilities.contains(.server)}
                completion(response)
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }
    }

    private func fetchLibraries(with token: String, from serverUri: String, completion: @escaping (Plex.Request.Libraries.Response?)->()) {
        guard let url = URL(string: serverUri) else { return }
        client.request(
            Plex.Request.Libraries(),
            from: url,
            token: PlexAuthentication.primaryToken
        ) { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }
    }

    public func fetchMovies(for username: String,
                            and password: String) {
        self.fetchAuthenticatedUserDetails(username: username,
                                           password: password) { userDetails in
            guard let token = userDetails?.user.authenticationToken else { return }
            self.findPlexResources(with: token) { plexResources in
                guard let uri = plexResources?.first?.connections.first?.uri else { return }
                self.fetchLibraries(with: PlexAuthentication.primaryToken,
                                    from: uri) { [self] libraries in
                    let mediaContainer = libraries?.mediaContainer
                    let movieLibraries = mediaContainer?.directory.filter { $0.type == .show }

                    guard let art = movieLibraries?.first?.art else { return }

                    let endpoint = String(describing: uri)

                    guard let urlEndpoint = URL(string: endpoint) else { return }

                    let key = movieLibraries?.first?.key
                    client.request(Plex.Request.Collections(libraryKey: key!, mediaType: .show), from: urlEndpoint, token: PlexAuthentication.primaryToken) { response in
                        dump(response)
                    }
                }
            }
        }
    }
}

//▿ 7 elements
//  ▿ PlexKit.PlexLibrary
//    - key: "5"
//    - uuid: "e7a8e71f-4b6d-4462-8ed9-a6eafac5c7b2"
//    - type: PlexKit.PlexMediaType.movie
//    ▿ allowSync: Optional(true)
//      - some: true
//    ▿ art: Optional("/:/resources/movie-fanart.jpg")
//      - some: "/:/resources/movie-fanart.jpg"
//    ▿ composite: Optional("/library/sections/5/composite/1719750998")
//      - some: "/library/sections/5/composite/1719750998"
//    ▿ filters: Optional(true)
//      - some: true
//    ▿ refreshing: Optional(false)
//      - some: false
//    ▿ thumb: Optional("/:/resources/movie.png")
//      - some: "/:/resources/movie.png"
//    ▿ title: Optional("05 - Movies New")
//      - some: "05 - Movies New"
//    ▿ agent: Optional("tv.plex.agents.movie")
//      - some: "tv.plex.agents.movie"
//    ▿ scanner: Optional("Plex Movie")
//      - some: "Plex Movie"
//    ▿ language: Optional("en-GB")
//      - some: "en-GB"
//    ▿ updatedAt: Optional(2024-06-30 12:37:25 +0000)
//      ▿ some: 2024-06-30 12:37:25 +0000
//        - timeIntervalSinceReferenceDate: 741443845.0
//    ▿ createdAt: Optional(2023-10-25 18:38:36 +0000)
//      ▿ some: 2023-10-25 18:38:36 +0000
//        - timeIntervalSinceReferenceDate: 719951916.0
//    ▿ scannedAt: Optional(2024-06-30 12:36:38 +0000)
//      ▿ some: 2024-06-30 12:36:38 +0000
//        - timeIntervalSinceReferenceDate: 741443798.0
//    ▿ Location: Optional([PlexKit.PlexLibrary.Location(id: 19, path: "X:\\Movies\\Movies New")])
//      ▿ some: 1 element
//        ▿ PlexKit.PlexLibrary.Location
//          - id: 19
//          - path: "X:\\Movies\\Movies New"
//  ▿ PlexKit.PlexLibrary
//    - key: "6"
//    - uuid: "1f3c51c2-bfba-4b13-95f1-340d1d740340"
//    - type: PlexKit.PlexMediaType.movie
//    ▿ allowSync: Optional(true)
//      - some: true
//    ▿ art: Optional("/:/resources/movie-fanart.jpg")
//      - some: "/:/resources/movie-fanart.jpg"
//    ▿ composite: Optional("/library/sections/6/composite/1719751000")
//      - some: "/library/sections/6/composite/1719751000"
//    ▿ filters: Optional(true)
//      - some: true
//    ▿ refreshing: Optional(false)
//      - some: false
//    ▿ thumb: Optional("/:/resources/movie.png")
//      - some: "/:/resources/movie.png"
//    ▿ title: Optional("06 - Movies Old")
//      - some: "06 - Movies Old"
//    ▿ agent: Optional("tv.plex.agents.movie")
//      - some: "tv.plex.agents.movie"
//    ▿ scanner: Optional("Plex Movie")
//      - some: "Plex Movie"
//    ▿ language: Optional("en-GB")
//      - some: "en-GB"
//    ▿ updatedAt: Optional(2024-06-30 12:37:35 +0000)
//      ▿ some: 2024-06-30 12:37:35 +0000
//        - timeIntervalSinceReferenceDate: 741443855.0
//    ▿ createdAt: Optional(2023-10-25 18:39:11 +0000)
//      ▿ some: 2023-10-25 18:39:11 +0000
//        - timeIntervalSinceReferenceDate: 719951951.0
//    ▿ scannedAt: Optional(2024-06-30 12:36:40 +0000)
//      ▿ some: 2024-06-30 12:36:40 +0000
//        - timeIntervalSinceReferenceDate: 741443800.0
//    ▿ Location: Optional([PlexKit.PlexLibrary.Location(id: 20, path: "X:\\Movies\\Movies Old")])
//      ▿ some: 1 element
//        ▿ PlexKit.PlexLibrary.Location
//          - id: 20
//          - path: "X:\\Movies\\Movies Old"
//  ▿ PlexKit.PlexLibrary
//    - key: "7"
//    - uuid: "886771de-f16c-44c3-8a37-1122282f5f71"
//    - type: PlexKit.PlexMediaType.movie
//    ▿ allowSync: Optional(true)
//      - some: true
//    ▿ art: Optional("/:/resources/movie-fanart.jpg")
//      - some: "/:/resources/movie-fanart.jpg"
//    ▿ composite: Optional("/library/sections/7/composite/1719751001")
//      - some: "/library/sections/7/composite/1719751001"
//    ▿ filters: Optional(true)
//      - some: true
//    ▿ refreshing: Optional(false)
//      - some: false
//    ▿ thumb: Optional("/:/resources/movie.png")
//      - some: "/:/resources/movie.png"
//    ▿ title: Optional("07 - Movies Docu")
//      - some: "07 - Movies Docu"
//    ▿ agent: Optional("tv.plex.agents.movie")
//      - some: "tv.plex.agents.movie"
//    ▿ scanner: Optional("Plex Movie")
//      - some: "Plex Movie"
//    ▿ language: Optional("en-GB")
//      - some: "en-GB"
//    ▿ updatedAt: Optional(2024-06-30 12:37:35 +0000)
//      ▿ some: 2024-06-30 12:37:35 +0000
//        - timeIntervalSinceReferenceDate: 741443855.0
//    ▿ createdAt: Optional(2023-10-25 18:39:45 +0000)
//      ▿ some: 2023-10-25 18:39:45 +0000
//        - timeIntervalSinceReferenceDate: 719951985.0
//    ▿ scannedAt: Optional(2024-06-30 12:36:41 +0000)
//      ▿ some: 2024-06-30 12:36:41 +0000
//        - timeIntervalSinceReferenceDate: 741443801.0
//    ▿ Location: Optional([PlexKit.PlexLibrary.Location(id: 30, path: "X:\\Documentaries\\Docu Movie")])
//      ▿ some: 1 element
//        ▿ PlexKit.PlexLibrary.Location
//          - id: 30
//          - path: "X:\\Documentaries\\Docu Movie"
//  ▿ PlexKit.PlexLibrary
//    - key: "8"
//    - uuid: "a065584a-88bf-4906-add2-459f0c1a6e27"
//    - type: PlexKit.PlexMediaType.movie
//    ▿ allowSync: Optional(true)
//      - some: true
//    ▿ art: Optional("/:/resources/movie-fanart.jpg")
//      - some: "/:/resources/movie-fanart.jpg"
//    ▿ composite: Optional("/library/sections/8/composite/1719751004")
//      - some: "/library/sections/8/composite/1719751004"
//    ▿ filters: Optional(true)
//      - some: true
//    ▿ refreshing: Optional(false)
//      - some: false
//    ▿ thumb: Optional("/:/resources/movie.png")
//      - some: "/:/resources/movie.png"
//    ▿ title: Optional("08 - Comedy")
//      - some: "08 - Comedy"
//    ▿ agent: Optional("tv.plex.agents.movie")
//      - some: "tv.plex.agents.movie"
//    ▿ scanner: Optional("Plex Movie")
//      - some: "Plex Movie"
//    ▿ language: Optional("en-GB")
//      - some: "en-GB"
//    ▿ updatedAt: Optional(2024-06-30 12:37:35 +0000)
//      ▿ some: 2024-06-30 12:37:35 +0000
//        - timeIntervalSinceReferenceDate: 741443855.0
//    ▿ createdAt: Optional(2023-10-26 05:37:07 +0000)
//      ▿ some: 2023-10-26 05:37:07 +0000
//        - timeIntervalSinceReferenceDate: 719991427.0
//    ▿ scannedAt: Optional(2024-06-30 12:36:44 +0000)
//      ▿ some: 2024-06-30 12:36:44 +0000
//        - timeIntervalSinceReferenceDate: 741443804.0
//    ▿ Location: Optional([PlexKit.PlexLibrary.Location(id: 22, path: "X:\\Comedy")])
//      ▿ some: 1 element
//        ▿ PlexKit.PlexLibrary.Location
//          - id: 22
//          - path: "X:\\Comedy"
//  ▿ PlexKit.PlexLibrary
//    - key: "10"
//    - uuid: "caf63b6d-f6ea-4d74-85f4-de5d0cb996fa"
//    - type: PlexKit.PlexMediaType.movie
//    ▿ allowSync: Optional(true)
//      - some: true
//    ▿ art: Optional("/:/resources/movie-fanart.jpg")
//      - some: "/:/resources/movie-fanart.jpg"
//    ▿ composite: Optional("/library/sections/10/composite/1719751601")
//      - some: "/library/sections/10/composite/1719751601"
//    ▿ filters: Optional(true)
//      - some: true
//    ▿ refreshing: Optional(false)
//      - some: false
//    ▿ thumb: Optional("/:/resources/video.png")
//      - some: "/:/resources/video.png"
//    ▿ title: Optional("10 - Music MP4")
//      - some: "10 - Music MP4"
//    ▿ agent: Optional("com.plexapp.agents.none")
//      - some: "com.plexapp.agents.none"
//    ▿ scanner: Optional("Plex Video Files Scanner")
//      - some: "Plex Video Files Scanner"
//    ▿ language: Optional("xn")
//      - some: "xn"
//    ▿ updatedAt: Optional(2024-06-30 12:47:36 +0000)
//      ▿ some: 2024-06-30 12:47:36 +0000
//        - timeIntervalSinceReferenceDate: 741444456.0
//    ▿ createdAt: Optional(2023-10-26 09:58:18 +0000)
//      ▿ some: 2023-10-26 09:58:18 +0000
//        - timeIntervalSinceReferenceDate: 720007098.0
//    ▿ scannedAt: Optional(2024-06-30 12:46:41 +0000)
//      ▿ some: 2024-06-30 12:46:41 +0000
//        - timeIntervalSinceReferenceDate: 741444401.0
//    ▿ Location: Optional([PlexKit.PlexLibrary.Location(id: 23, path: "X:\\Music Videos\\Music Videos")])
//      ▿ some: 1 element
//        ▿ PlexKit.PlexLibrary.Location
//          - id: 23
//          - path: "X:\\Music Videos\\Music Videos"
//  ▿ PlexKit.PlexLibrary
//    - key: "11"
//    - uuid: "9a63edc5-59e0-42b4-818b-bf85c4adeecc"
//    - type: PlexKit.PlexMediaType.movie
//    ▿ allowSync: Optional(true)
//      - some: true
//    ▿ art: Optional("/:/resources/movie-fanart.jpg")
//      - some: "/:/resources/movie-fanart.jpg"
//    ▿ composite: Optional("/library/sections/11/composite/1719751632")
//      - some: "/library/sections/11/composite/1719751632"
//    ▿ filters: Optional(true)
//      - some: true
//    ▿ refreshing: Optional(false)
//      - some: false
//    ▿ thumb: Optional("/:/resources/video.png")
//      - some: "/:/resources/video.png"
//    ▿ title: Optional("11 - Music DVD")
//      - some: "11 - Music DVD"
//    ▿ agent: Optional("com.plexapp.agents.none")
//      - some: "com.plexapp.agents.none"
//    ▿ scanner: Optional("Plex Video Files Scanner")
//      - some: "Plex Video Files Scanner"
//    ▿ language: Optional("xn")
//      - some: "xn"
//    ▿ updatedAt: Optional(2024-06-30 12:48:07 +0000)
//      ▿ some: 2024-06-30 12:48:07 +0000
//        - timeIntervalSinceReferenceDate: 741444487.0
//    ▿ createdAt: Optional(2023-10-26 10:50:45 +0000)
//      ▿ some: 2023-10-26 10:50:45 +0000
//        - timeIntervalSinceReferenceDate: 720010245.0
//    ▿ scannedAt: Optional(2024-06-30 12:47:12 +0000)
//      ▿ some: 2024-06-30 12:47:12 +0000
//        - timeIntervalSinceReferenceDate: 741444432.0
//    ▿ Location: Optional([PlexKit.PlexLibrary.Location(id: 24, path: "X:\\Music Videos\\DVD")])
//      ▿ some: 1 element
//        ▿ PlexKit.PlexLibrary.Location
//          - id: 24
//          - path: "X:\\Music Videos\\DVD"
//  ▿ PlexKit.PlexLibrary
//    - key: "12"
//    - uuid: "a31d2332-1c26-43bd-be3d-69db40f823cf"
//    - type: PlexKit.PlexMediaType.movie
//    ▿ allowSync: Optional(true)
//      - some: true
//    ▿ art: Optional("/:/resources/movie-fanart.jpg")
//      - some: "/:/resources/movie-fanart.jpg"
//    ▿ composite: Optional("/library/sections/12/composite/1719751677")
//      - some: "/library/sections/12/composite/1719751677"
//    ▿ filters: Optional(true)
//      - some: true
//    ▿ refreshing: Optional(false)
//      - some: false
//    ▿ thumb: Optional("/:/resources/video.png")
//      - some: "/:/resources/video.png"
//    ▿ title: Optional("12 - Music Blu-Ray")
//      - some: "12 - Music Blu-Ray"
//    ▿ agent: Optional("com.plexapp.agents.none")
//      - some: "com.plexapp.agents.none"
//    ▿ scanner: Optional("Plex Video Files Scanner")
//      - some: "Plex Video Files Scanner"
//    ▿ language: Optional("xn")
//      - some: "xn"
//    ▿ updatedAt: Optional(2024-06-30 12:48:52 +0000)
//      ▿ some: 2024-06-30 12:48:52 +0000
//        - timeIntervalSinceReferenceDate: 741444532.0
//    ▿ createdAt: Optional(2023-10-26 11:49:51 +0000)
//      ▿ some: 2023-10-26 11:49:51 +0000
//        - timeIntervalSinceReferenceDate: 720013791.0
//    ▿ scannedAt: Optional(2024-06-30 12:47:57 +0000)
//      ▿ some: 2024-06-30 12:47:57 +0000
//        - timeIntervalSinceReferenceDate: 741444477.0
//    ▿ Location: Optional([PlexKit.PlexLibrary.Location(id: 25, path: "X:\\Music Videos\\Blu-Ray")])
//      ▿ some: 1 element
//        ▿ PlexKit.PlexLibrary.Location
//          - id: 25
//          - path: "X:\\Music Videos\\Blu-Ray"
