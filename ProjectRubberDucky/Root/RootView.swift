//
//  RootView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct RootView: View {
    let feature: any Feature

    @State var isLaunching: Bool = true
    @Environment(AppStyling.self) var appStyling

    init(feature: any Feature) {
        self.feature = feature
    }

    var body: some View {
        if isLaunching {
            LaunchingView(isLaunching: $isLaunching)
        } else {
            AnyView(feature.featureView)
                .tint(appStyling.tintColor)
        }
    }
}
