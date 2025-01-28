//
//  OnboardingProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import SwiftUI

@Observable
class OnboardingProvider: FeatureProvider {
    typealias DataModel = [OnboardingDataModel]

    public var viewState: ViewState<DataModel>

    private var userDefaultsManager: UserDefaultsManager
    private var tabFeatureFlagProvider: TabFeatureFlagProvidable

    init(userDefaultsManager: UserDefaultsManager,
         tabFeatureFlagProvider: TabFeatureFlagProvidable) {
        self.userDefaultsManager = userDefaultsManager
        self.tabFeatureFlagProvider = tabFeatureFlagProvider
        viewState = .loading
    }

    func fetchContent() async {
        if userDefaultsManager.hasSeenboarding {
            let dataModel: DataModel = await createDataModel()

            await MainActor.run {
                viewState = .presenting(using: dataModel)
            }
        } else {
            await MainActor.run {
                viewState = .none
            }
        }
    }

    private func createDataModel() async -> DataModel {
        var dataModel: DataModel = []
        var tagIndex: Int = -1

        if tabFeatureFlagProvider.fetchHomeTabFeatreFlag() {
            tagIndex += 1
            dataModel.append(OnboardingDataModel(title: "Home",
                                                 description: "This is where you can find your recommended content.",
                                                 buttonTitle: "Next",
                                                 image: Image(systemName: "house.fill"),
                                                 tag: tagIndex))
        }

        if tabFeatureFlagProvider.fetcSearchTabFeatreFlag() {
            tagIndex += 1
            dataModel.append(OnboardingDataModel(title: "Search",
                                                 description: "This is where you can search for content.",
                                                 buttonTitle: "Next",
                                                 image: Image(systemName: "magnifyingglass"),
                                                 tag: tagIndex))
        }

        if tabFeatureFlagProvider.fetchLibraryTabFeatreFlag() {
            tagIndex += 1
            dataModel.append(OnboardingDataModel(title: "Library",
                                                 description: "This is where you can find your saved content.",
                                                 buttonTitle: "Next",
                                                 image: Image(systemName: "books.vertical.fill"),
                                                 tag: tagIndex))
        }

        if tabFeatureFlagProvider.fetchSettingsTabFeatreFlag() {
            tagIndex += 1
            dataModel.append(OnboardingDataModel(title: "Settings",
                                                 description: "This is where you can access your profile settings.",
                                                 buttonTitle: "Done",
                                                 image: Image(systemName: "gear"),
                                                 tag: tagIndex))
        }

        return dataModel
    }
}
