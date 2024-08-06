import SwiftUI
import FirebaseCore
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
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupFirebase()
        setupAVAudioSession()
        return true
    }

    private func setupFirebase() {
        FirebaseApp.configure()
    }

    private func setupAVAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true, options: [])
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
}
