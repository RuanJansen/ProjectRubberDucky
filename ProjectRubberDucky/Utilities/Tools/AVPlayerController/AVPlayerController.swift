//
//  PlayerController.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/27.
//

import Foundation
import AVKit
import SwiftUI

@Observable
class AVPlayerController {
    private let videoFileURL: URL
    private var player: AVPlayer?
    
    var avPlayerViewController: AVPlayerViewController?

    init(videoFileURL: URL) {
        self.videoFileURL = videoFileURL
        self.avPlayerViewController = AVPlayerViewController()
        setupPlayer()
        setupAVPlayerViewController()
        playPlayer()
    }

    // MARK: - Teardown
    public func teardownPlayer() {
        pausePlayer()
        player = nil
        avPlayerViewController = nil
    }

    // MARK: - Setup
    private func setupPlayer() {
        let playerItem = AVPlayerItem(asset: AVURLAsset(url: videoFileURL))
        player = AVPlayer(playerItem: playerItem)
    }
    
    // MARK: - AVPlayerViewController Setup
    private func setupAVPlayerViewController() {
        // Assign AVPlayer to AVPlayerViewController
        avPlayerViewController?.player = player
        avPlayerViewController?.allowsPictureInPicturePlayback = true
        #if os(iOS)
        avPlayerViewController?.canStartPictureInPictureAutomaticallyFromInline = true
        #endif
    }

    // MARK: - Playback Control

    func pausePlayer() {
        player?.pause()
    }

    func playPlayer() {
        player?.play()
    }
}
