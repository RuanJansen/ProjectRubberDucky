//
//  OnboardingDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import SwiftUI

struct OnboardingDataModel: Identifiable {
    var id: UUID
    let title: String
    let description: String
    let buttonTitle: String
    let image: Image?
    let tag: Int

    init(title: String,
         description: String,
         buttonTitle: String,
         image: Image? = nil,
         tag: Int) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.image = image
        self.tag = tag
    }
}
