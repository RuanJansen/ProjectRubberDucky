//
//  RootView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct RootView: View {
    @State var navigationManager: NavigationManager

    @Environment(AppStyling.self) var appStyling

    init(navigationManager: NavigationManager) {
        self._navigationManager = State(wrappedValue: navigationManager)
    }

    var body: some View {
        Group {
            switch navigationManager.navigationState {
            case .mainView(let mainView, let onboardingView):
                mainView
                    .sheet(isPresented: navigationManager.onboardingUsecase.$isShowingOnboarding) {
                        onboardingView
                            .environment(self.appStyling)
                    }
            case .authenticationView(let authenticationView):
                authenticationView
            case .launchingView:
                LaunchingView(isLaunching: $navigationManager.isLaunching)
            }
        }
        .task {
            await navigationManager.fetch()
        }
        .tint(appStyling.tintColor)
    }
}
