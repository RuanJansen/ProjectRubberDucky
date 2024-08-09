//
//  AccountProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import Observation
import SwiftUI

@Observable
class AccountProvider: FeatureProvider {
    typealias DataModel = AccountDataModel

    var viewState: ViewState<AccountDataModel>

    private var authenticationManager: AuthenticationManager

    init(authenticationManager: AuthenticationManager) {
        self.viewState = .loading
        self.authenticationManager = authenticationManager
    }

    func fetchContent() async {
        self.viewState = await .presentContent(using: AccountDataModel(deleteAccountSection: SectionItemDataModel(title: "Delete Account",
                                                                                                            buttonAction: .alert(setupDeleteAlert()),
                                                                                                            fontColor: .white)))
    }

    private func setupDeleteAlert() async -> RDAlertModel {
        return RDAlertModel(title: "Delete Account",
                            message: "Are you sure you would like to delete your account?",
                            buttons: [
                                RDAlertButtonModel(title: "Cancel", action: {}, role: .cancel),
                                RDAlertButtonModel(title: "Delete", action: {
                                    Task {
                                        await self.deleteAccount()
                                    }
                                }, role: .destructive)
                            ])
    }

    private func deleteAccount() async {
        await authenticationManager.deleteAccount()
    }
}
