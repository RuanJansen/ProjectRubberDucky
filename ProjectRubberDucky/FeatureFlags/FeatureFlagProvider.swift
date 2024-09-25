//
//  FeatureFlagManager.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/11.
//

import Foundation

class FeatureFlagProvider {
    let featureFlagFetcher: FeatureFlagFetcher

    init(featureFlagFetcher: FeatureFlagFetcher) {
        self.featureFlagFetcher = featureFlagFetcher
    }
}

protocol TabFeatureFlagProvidable {
    func fetchHomeTabFeatreFlag() -> Bool
    func fetcSearchTabFeatreFlag() -> Bool
    func fetchLibraryTabFeatreFlag() -> Bool
    func fetchSettingsTabFeatreFlag() -> Bool 
}

extension FeatureFlagProvider: TabFeatureFlagProvidable {
    public func fetchHomeTabFeatreFlag() -> Bool {
        guard let flag = featureFlagFetcher.fetch(flag: "homeTabFeatureFlag") else { return false }
        return flag
    }

    public func fetcSearchTabFeatreFlag() -> Bool {
        guard let flag = featureFlagFetcher.fetch(flag: "searchTabFeatureFlag") else { return false }
        return flag
    }

    public func fetchLibraryTabFeatreFlag() -> Bool {
        guard let flag = featureFlagFetcher.fetch(flag: "libraryTabFeatureFlag") else { return false }
        return flag
    }

    public func fetchSettingsTabFeatreFlag() -> Bool {
        guard let flag = featureFlagFetcher.fetch(flag: "settingsTabFeatureFlag") else { return false }
        return flag
    }
}
