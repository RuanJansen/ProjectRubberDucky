//
//  AccountDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import Foundation

struct AccountDataModel {
    let pageTitle: String
    let user: UserDataModel?
    let profileImageButtonAction: RDButtonAction?
    let sections: [SectionDataModel]

    init(pageTitle: String, user: UserDataModel? = nil, profileImageButtonAction: RDButtonAction? = nil, sections: [SectionDataModel]) {
        self.pageTitle = pageTitle
        self.user = user
        self.profileImageButtonAction = profileImageButtonAction
        self.sections = sections
    }
}
