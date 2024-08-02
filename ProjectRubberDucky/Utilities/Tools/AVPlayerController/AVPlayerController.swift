//
//  PlayerController.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/27.
//

import Foundation
import AVKit
import SwiftUI

class AVPlayerController: ObservableObject {
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
        playPlayer()
        print(UUID().uuidString)
    }

    // MARK: - AVPlayer Setup
//    private func setupPlayer() {
//        // Initialize AVPlayer with the provided video link
//        let headers = ["X-Plex-Token": PlexAuthentication.primaryToken]
//        let options = ["AVURLAssetHTTPHeaderFieldsKey": headers]
//
//        let asset = AVURLAsset(url: link, options: options)
//
//        // Check if the asset is playable
//        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
//            var error: NSError? = nil
//            let status = asset.statusOfValue(forKey: "playable", error: &error)
//            if status == .loaded {
//                DispatchQueue.main.async {
//                    let playerItem = AVPlayerItem(asset: asset)
//                    self.player = AVPlayer(playerItem: playerItem)
//                }
//            } else {
//                print("Error: \(String(describing: error?.localizedDescription))")
//            }
//        }
//    }

    private func setupPlayer() {
        // Initialize AVPlayer with the provided video link
        let headers = ["X-Plex-Token": PlexAuthentication.token]

        let asset = AVURLAsset(url: link, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])

        let playerItem = AVPlayerItem(asset: asset)

        player = AVPlayer(playerItem: playerItem)
    }
    // MARK: - AVPlayerViewController Setup

    private func setupAVPlayerViewController() {
        // Assign AVPlayer to AVPlayerViewController
        avPlayerViewController.player = player
        avPlayerViewController.allowsPictureInPicturePlayback = true
        #if os(iOS)
        avPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = true
        #endif
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
