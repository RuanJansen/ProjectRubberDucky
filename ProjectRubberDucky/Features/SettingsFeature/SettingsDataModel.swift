//
//  SettingsDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct SettingsDataModel {
    let user: UserDataModel?
    let sections: [SettingsSection]
    let logOut: SettingsLogOutDataModel
    let build: String?

    init(user: UserDataModel?, sections: [SettingsSection], logOut: SettingsLogOutDataModel, build: String?) {
        self.user = user
        self.sections = sections
        self.logOut = logOut
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

struct SettingsLogOutDataModel {
    let title: String
    let action: RDButtonAction
}
