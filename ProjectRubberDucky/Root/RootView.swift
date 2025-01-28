//
//  RootView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct RootView: View {
    private let mainFeature: any Feature
    
    @Environment(AppStyling.self) var appStyling

    init(mainFeature: any Feature) {
        self.mainFeature = mainFeature
    }

    var body: some View {
        Group {
            AnyView(mainFeature.featureView)
        }
        .tint(appStyling.tintColor)
    }
}
