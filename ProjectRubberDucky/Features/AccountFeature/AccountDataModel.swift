//
//  AccountDataModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import Foundation

struct AccountDataModel {
    let user: UserDataModel?
    let profileImageButtonAction: RDButtonAction?
    let sections: [SectionDataModel]

    init(user: UserDataModel? = nil, profileImageButtonAction: RDButtonAction? = nil, sections: [SectionDataModel]) {
        self.user = user
        self.profileImageButtonAction = profileImageButtonAction
        self.sections = sections
    }
}
