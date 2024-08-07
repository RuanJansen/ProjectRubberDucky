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

    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
        viewState = .loading
    }

    func fetchContent() async {
        if userDefaultsManager.shouldShowOnboarding {
            let dataModel: DataModel = [
                OnboardingDataModel(title: "Home",
                                    description: "This is where you can find your recommended content.",
                                    buttonTitle: "Next",
                                    image: Image(systemName: "house.fill"),
                                    tag: 0),
                OnboardingDataModel(title: "Subscribed",
                                    description: "This is where you can find the creators you are sunscribed to.",
                                    buttonTitle: "Next",
                                    image: Image(systemName: "tv.badge.wifi"),
                                    tag: 1),
                OnboardingDataModel(title: "Library",
                                    description: "This is where you can find your saved content.",
                                    buttonTitle: "Next",
                                    image: Image(systemName: "books.vertical.fill"),
                                    tag: 2),
                OnboardingDataModel(title: "Settings",
                                    description: "This is where you can access your profile settings.",
                                    buttonTitle: "Done",
                                    image: Image(systemName: "gear"),
                                    tag: 3)
            ]

            await MainActor.run {
                viewState = .presentContent(using: dataModel)
            }
        } else {
            await MainActor.run {
                viewState = .none
            }
        }
    }
    
}
