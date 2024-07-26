//
//  OnboardingUsecase.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import SwiftUI

class OnboardingUsecase: ObservableObject {
    @AppStorage("isShowingOnboarding") var isShowingOnboarding: Bool = true

}
