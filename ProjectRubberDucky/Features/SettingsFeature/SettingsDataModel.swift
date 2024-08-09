//
//  SettingsDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct SettingsDataModel {
    let account: SettingsAccountDataModel?
    let sections: [SectionDataModel]
    let logOut: LogOutDataModel
    let build: String?

    init(account: SettingsAccountDataModel?, sections: [SectionDataModel], logOut: LogOutDataModel, build: String?) {
        self.account = account
        self.sections = sections
        self.logOut = logOut
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
    let items: [SectionItemDataModel]

    init(header: String? = nil, items: [SectionItemDataModel]) {
        self.id = UUID()
        self.header = header
        self.items = items
    }
}

struct SectionItemDataModel: Identifiable {
    let id: UUID
    let title: String
    let buttonAction: RDButtonAction
    let fontColor: Color

    init(title: String, buttonAction: RDButtonAction, fontColor: Color = .primary) {
        self.id = UUID()
        self.title = title
        self.buttonAction = buttonAction
        self.fontColor = fontColor
    }
}

struct LogOutDataModel {
    let title: String
    let action: RDButtonAction
}
