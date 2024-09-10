//
//  LaunchingView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/06.
//

import SwiftUI

struct SplashScreenView: View {
    @Environment(AppStyling.self) var appStyling

    @State private var scale = 0.5

    var body: some View {
        VStack {
            appStyling.appIconImage
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .frame(width: 150)
                .scaleEffect(scale)
            Text(appStyling.appName)
        }
        .font(.title)
        .foregroundStyle(appStyling.tintColor)
        .onAppear {
            withAnimation(.bouncy(duration: 2)) {
                scale = 1
            }
        }
    }
}
