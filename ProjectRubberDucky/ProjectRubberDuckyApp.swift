import SwiftUI
import AVKit

@main
struct ProjectRubberDuckyApp: App {
    let rootComponent: RootComponent

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        registerProviderFactories()
        self.rootComponent = DependencyContainer.shared.rootComponent
    }

    var body: some Scene {
        WindowGroup {
            rootComponent.view
        }
    }
}

class DependencyContainer {
    static let shared = DependencyContainer()

    let rootComponent: RootComponent

    init() {
        self.rootComponent = RootComponent()
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
