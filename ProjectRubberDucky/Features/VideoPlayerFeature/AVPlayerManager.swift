//
//  AVPlayerManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/27.
//

import Foundation
import AVKit
import SwiftUI

class PlayerController: ObservableObject {
    @Published var link: URL
    @Published var title: String
    @Published var publisher: String
    @Published var thumbnail: URL

    var player: AVPlayer?
    var avPlayerViewController: AVPlayerViewController

    init(link: URL,
         title: String,
         publisher: String,
         thumbnail: URL) {
        self.link = link
        self.title = title
        self.publisher = publisher
        self.thumbnail = thumbnail
        self.avPlayerViewController = AVPlayerViewController()
        setupPlayer()
        setupAVPlayerViewController()
    }

    // MARK: - AVPlayer Setup

    private func setupPlayer() {
        // Initialize AVPlayer with the provided video link
        player = AVPlayer(url: link)
    }
    // MARK: - AVPlayerViewController Setup

    private func setupAVPlayerViewController() {
        // Assign AVPlayer to AVPlayerViewController
        avPlayerViewController.player = player
        avPlayerViewController.allowsPictureInPicturePlayback = true
        avPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = true
    }

    // MARK: - Playback Control

    // Pause the AVPlayer
    func pausePlayer() {
        player?.pause()
    }

    // Play the AVPlayer
    func playPlayer() {
        player?.play()
    }
}

// A SwiftUI view wrapper for an AVPlayerViewController
struct VideoPlayer: UIViewControllerRepresentable {
    // MARK: - Observed Object

    // ObservedObject that manages the underlying AVPlayer and its playback state
    @ObservedObject var playerController: PlayerController

    // MARK: - UIViewControllerRepresentable Protocol Methods

    // Update the AVPlayerViewController when SwiftUI view updates
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update the view controller if needed
        // (e.g., handle updates when the underlying AVPlayer changes)
    }

    // Create and configure the AVPlayerViewController
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return playerController.avPlayerViewController
    }
}
