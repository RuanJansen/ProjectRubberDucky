//
//  OnboardingProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import Foundation

class OnboardingProvider: FeatureProvider {
    typealias DataModel = [OnboardingDataModel]

    @Published var viewState: ViewState<DataModel>

    private var onboardingUsecase: OnboardingUsecase

    init(onboardingUsecase: OnboardingUsecase) {
        self.onboardingUsecase = onboardingUsecase
        viewState = .loading
    }

    func fetchContent() async {
        if onboardingUsecase.isShowingOnboarding {
            let dataModel: DataModel = [
                OnboardingDataModel(title: "Home",
                                    description: "This is where you can find your recommended content.",
                                    buttonTitle: "Next",
                                    tag: 0),
                OnboardingDataModel(title: "Library",
                                    description: "This is where you can find your saved content.",
                                    buttonTitle: "Next",
                                    tag: 1),
                OnboardingDataModel(title: "Profile",
                                    description: "This is where you can access your profile settings.",
                                    buttonTitle: "Done",
                                    tag: 2)
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
