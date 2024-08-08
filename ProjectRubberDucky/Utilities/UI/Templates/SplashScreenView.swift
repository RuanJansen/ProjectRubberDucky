//
//  LaunchingView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/06.
//

import SwiftUI

struct SplashScreenView: View {
    @Environment(AppStyling.self) var appStyling

    var body: some View {
        VStack {
            appStyling.appIconImage
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 150)
            Text(appStyling.appName)
        }
        .font(.title)
        .foregroundStyle(appStyling.tintColor)
    }
}
