//
//  VideoPlayerComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/23.
//

import Foundation
import NeedleFoundation
import SwiftUI

extension RootComponent {
    public var videoPlayerComponent: VideoPlayerComponent {
        VideoPlayerComponent(parent: self)
    }

    public var videoPlayerFeatureProvider: any FeatureProvider {
        VideoPlayerProvider(repository: videoRepository)
    }

    public var videoRepository: VideoRepository {
        VideoRepository()
    }
}

class VideoPlayerComponent: Component<VideoPlayerDependency> {
    public var feature: Feature {
        VideoPlayerFeature(featureProvider: featureProvider)
    }

    public var featureProvider: any FeatureProvider {
        dependency.videoPlayerFeatureProvider
    }
}

