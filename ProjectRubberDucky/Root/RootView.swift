//
//  RootView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct RootView: View {
    @Bindable var navigationManager: NavigationManager

    @Environment(AppStyling.self) var appStyling

    init(navigationManager: NavigationManager) {
        self._navigationManager = Bindable(wrappedValue: navigationManager)
    }

    var body: some View {
        Group {
            switch navigationManager.navigationState {
            case .mainView(let mainView, let onboardingView):
                mainView
                    .sheet(isPresented: $navigationManager.showOnboardingSheet) {
                        onboardingView
                            .environment(self.appStyling)
                    }

            case .authenticationView(let authenticationView):
                authenticationView
            case .launchingView:
                LaunchingView()
            }
        }
        .task {
            await navigationManager.fetchContent()
        }
        .tint(appStyling.tintColor)
    }
}
