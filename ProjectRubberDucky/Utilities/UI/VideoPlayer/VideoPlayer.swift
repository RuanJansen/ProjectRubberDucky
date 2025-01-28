import Foundation
import SwiftUI
import AVKit

struct VideoPlayer: UIViewControllerRepresentable {
    @State var playerController: AVPlayerController

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return playerController.avPlayerViewController!
    }
}
