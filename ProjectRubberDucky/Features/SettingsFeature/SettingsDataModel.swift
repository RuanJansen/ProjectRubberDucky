//
//  SettingsDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct SettingsDataModel {
    let pageTitle: String
    let account: SettingsAccountDataModel?
    let sections: [SectionDataModel]
    let build: String?

    init(pageTitle: String, account: SettingsAccountDataModel?, sections: [SectionDataModel], build: String?) {
        self.pageTitle = pageTitle
        self.account = account
        self.sections = sections
        self.build = build
    }
}

struct SettingsAccountDataModel {
    let imageURL: URL?
    let title: String?
    let action: RDButtonAction

    init(imageURL: URL?, title: String?, action: RDButtonAction) {
        self.imageURL = imageURL
        self.title = title
        self.action = action
    }
}

struct SectionDataModel: Identifiable {
    let id: UUID
    let header: String?
    let footer: String?
    let items: [SectionItemDataModel]

    init(header: String? = nil, footer: String? = nil, items: [SectionItemDataModel]) {
        self.id = UUID()
        self.header = header
        self.footer = footer
        self.items = items
    }
}

struct SectionItemDataModel: Identifiable {
    let id: UUID
    let title: String
    let buttonAction: RDButtonAction?
    let fontColor: Color
    let hasMaxWidth: Bool

    init(title: String, buttonAction: RDButtonAction? = nil, fontColor: Color = .primary, hasMaxWidth: Bool = false) {
        self.id = UUID()
        self.title = title
        self.buttonAction = buttonAction
        self.fontColor = fontColor
        self.hasMaxWidth = hasMaxWidth
    }
}
