import Foundation
import SwiftUI
import AVKit

// A SwiftUI view wrapper for an AVPlayerViewController
struct VideoPlayer: UIViewControllerRepresentable {
    // MARK: - Observed Object
    @ObservedObject var playerController: AVPlayerController

    // MARK: - UIViewControllerRepresentable Protocol Methods
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return playerController.avPlayerViewController
    }
}
