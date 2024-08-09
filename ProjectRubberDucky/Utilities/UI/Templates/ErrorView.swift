//
//  ErrorView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct ErrorDataModel: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let image: Image

    init(title: String, description: String, image: Image) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.image = image
    }
}

struct ErrorView: View {
    let errorModel: ErrorDataModel

    init(errorModel: ErrorDataModel) {
        self.errorModel = errorModel
    }

    var body: some View {
        VStack {
            Text(errorModel.title)
                .font(.title3)
                .padding()
            Text(errorModel.description)
                .font(.body)
            errorModel.image
                .font(.title3)
                .foregroundStyle(.red)
                .padding()
        }
//        .alert(isPresented: $showAlert) {
//            let alert = alertModel!
//
//            let title: Text = Text(alert.title)
//            let message: Text? = alert.message != nil ? Text(alert.message!) : nil
//            let primaryButton: Alert.Button = .default(Text(alert.primaryButtonTitle), action: alert.primaryAction)
//            let secondaryButton: Alert.Button = .cancel(Text(alert.secondaryButtonTitle), action: alert.secondaryAction)
//
//            return Alert(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
//        }
    }
}
