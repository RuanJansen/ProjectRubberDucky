//
//  SettingsDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct SettingsDataModel {
    let sections: [SettingsSection]
    let build: String

    init(sections: [SettingsSection], build: String) {
        self.sections = sections
        self.build = build
    }
}

struct SettingsSection: Identifiable {
    let id: UUID
    let header: String?
    let items: [SettingsSectionItem]

    init(header: String? = nil, items: [SettingsSectionItem]) {
        self.id = UUID()
        self.header = header
        self.items = items
    }
}

struct SettingsSectionItem: Identifiable {
    let id: UUID
    let title: String
    let buttonAction: RDButtonAction?
    let fontColor: Color

    init(title: String, buttonAction: RDButtonAction? = nil, fontColor: Color = .primary) {
        self.id = UUID()
        self.title = title
        self.buttonAction = buttonAction
        self.fontColor = fontColor
    }
}

enum RDButtonAction {
    case action(Void)
    case sheet(AnyView)
    case pushNavigation(AnyView)
    case alert(title: String,
               message: String,
               primaryAction: Void,
               secondaryAction: Void? = nil)
}
