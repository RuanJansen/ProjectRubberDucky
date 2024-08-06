//
//  LaunchingView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/06.
//

import SwiftUI

struct LaunchingView: View {
    @Binding var isLaunching: Bool
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                isLaunching.toggle()
            }
        }
    }
}
