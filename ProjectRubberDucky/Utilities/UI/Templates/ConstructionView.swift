//
//  ConstructionView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct ConstructionView: View {
    @Environment(AppStyling.self) var appStyling

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
            Text("Feature is currently under construction")
        }
        .foregroundStyle(appStyling.tintColor)
    }
}

