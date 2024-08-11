//
//  FeatureFlagFetcher.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/11.
//

import Foundation

class FeatureFlagFetcher {
    private var firebaseFeatureFlagFetcher: FeatureFlagFetchable

    init(firebaseFeatureFlagFetcher: FeatureFlagFetchable) {
        self.firebaseFeatureFlagFetcher = firebaseFeatureFlagFetcher
    }

    public func fetch(flag key: String) -> Bool? {
        let flag = firebaseFeatureFlagFetcher.fetchFeatureFlag(forKey: key)
        return flag
    }
}
