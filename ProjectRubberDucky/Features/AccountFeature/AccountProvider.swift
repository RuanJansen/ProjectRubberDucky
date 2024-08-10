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
    private var firebaseProvider: FirebaseProvider?
    
    private var currentUser: UserDataModel?

    init(authenticationManager: AuthenticationManager,
         firebaseProvider: FirebaseProvider?) {
        self.viewState = .loading
        self.authenticationManager = authenticationManager
        self.firebaseProvider = firebaseProvider
    }

    func fetchContent() async {
        await updateUser()
        self.viewState = await .presentContent(using: AccountDataModel(user: currentUser,
                                                                       sections: [SectionDataModel(items: [SectionItemDataModel(title: "Delete Account",
                                                                                                                                buttonAction: .alert(setupDeleteAlert()),
                                                                                                                                fontColor: .red,
                                                                                                                                hasMaxWidth: true)])]))
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

    private func updateUser() async {
        currentUser = await firebaseProvider?.fetchUser()
    }
}
