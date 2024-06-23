//
//  VideoPlayerFeature.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/23.
//

import Foundation
import SwiftUI
import NeedleFoundation

class VideoPlayerFeature<Provider>: Feature where Provider: VideoPlayerProvider {
    var featureProvider: any FeatureProvider

    init(featureProvider: any FeatureProvider) {
        self.featureProvider = featureProvider
    }

    public var featureView: any FeatureView {
        VideoPlayerView(provider: featureProvider as! Provider)
    }
}
