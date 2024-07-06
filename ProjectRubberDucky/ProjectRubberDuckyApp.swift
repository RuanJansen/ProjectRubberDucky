import SwiftUI
import AVKit
import NeedleFoundation

@main
struct ProjectRubberDuckyApp: App {
    let rootComponent: RootComponent

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        registerProviderFactories()
        self.rootComponent = DependencyManager.shared.rootComponent
    }

    var body: some Scene {
        WindowGroup {
            rootComponent.view
                .task {
                    let url = "https://172-29-6-20.6ff3f28836a64e218c04da392a2c3365.plex.direct:32400/library/metadata/27186/thumb/1716777535"

//                    let url = "https://172-29-6-20.6ff3f28836a64e218c04da392a2c3365.plex.direct:32400/library/metadata/27186"

//                    await PlexRepository(plexCaller: PlexGateway(username: PlexAuthentication.ruan.username, password: PlexAuthentication.ruan.password)).fetchTest()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true, options: [])
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }

        return true
    }
}
