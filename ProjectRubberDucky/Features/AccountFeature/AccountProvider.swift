//
//  AccountProvider.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import Observation
import SwiftUI
import Combine

@Observable
class AccountProvider: FeatureProvider {
    typealias DataModel = AccountDataModel

    var viewState: ViewState<AccountDataModel>

    private let contentProvider: AccountContentProvidable
    private var authenticationManager: AuthenticationManager
    private var firebaseProvider: FirebaseProvider?
    private var photosPickerManager: PhotosPickerManager
    private var shouldReauthenticate: Bool
    private var currentUser: UserDataModel?

    private var cancellables = Set<AnyCancellable>()

    init(contentProvider: AccountContentProvidable,
         authenticationManager: AuthenticationManager,
         firebaseProvider: FirebaseProvider?) {
        self.viewState = .loading
        self.contentProvider = contentProvider
        self.authenticationManager = authenticationManager
        self.firebaseProvider = firebaseProvider
        self.photosPickerManager = PhotosPickerManager()
        self.shouldReauthenticate = false
        self.startObserving()
    }

    func addListeners() {
        photosPickerManager.$selection.sink { selection in
            Task {
                do {
                    if let data = try await self.photosPickerManager.fetchImageData() {
                        self.savePhotoURL(from: data)
                    }
                } catch {

                }
            }
        }
        .store(in: &cancellables)
    }

    func startObserving() {
        _ = withObservationTracking {
            shouldReauthenticate
        } onChange: {
            Task {
                await self.fetchContent()
            }
        }
    }

    func fetchContent() async {
        await fetchUser()
        let pageTitle = await contentProvider.fetchPageTitle()
        let deleteAlertModel = await setupDeleteAlert()
        let deleteText = await contentProvider.fetchDeleteText()
        let profileImageButtonAction: RDButtonAction? = nil
        //        let profileImageButtonAction: RDButtonAction = .photosPicker {
        //            RDPhotosPickerModel()
        //        } selection: { selection in
        //            self.photosPickerManager.selection = selection
        //        }

        let reauthenticateAlertModel = RDAlertModel(title: "Re-authenticate Account",
                                                    message: "There was an error deleting your account. You have been signed in for too long and need to reauthenticate your account. Log out and retry this action after you have signed in again.",
                                                    buttons: [
                                                        RDAlertButtonModel(title: "Cancel", action: {}, role: .cancel),
                                                        RDAlertButtonModel(title: "Log out", action: {
                                                            Task {
                                                                await self.logOut()
                                                            }
                                                        }, role: .destructive)
                                                    ])
        var deleteErrorFooterMessage: String? = nil

        if shouldReauthenticate {
            deleteErrorFooterMessage = "There was an error deleting your account. You have been signed in for too long and need to reauthenticate your account. Log out and retry this action after you have signed in again."
        }

        let sections = [SectionDataModel(footer: deleteErrorFooterMessage,
                                         items: [
                                            SectionItemDataModel(title: deleteText,
                                                                 buttonAction: .alert {
                                                                     self.shouldReauthenticate ? reauthenticateAlertModel : deleteAlertModel
                                                                 },
                                                                 fontColor: .red,
                                                                 hasMaxWidth: true)])
        ]

        await MainActor.run {
            self.viewState = .presentContent(using: AccountDataModel(pageTitle: pageTitle,
                                                                     user: currentUser,
                                                                     profileImageButtonAction: profileImageButtonAction,
                                                                     sections: sections))
        }
    }

    private func setupDeleteAlert() async -> RDAlertModel {
        let accountAlertTitle = await contentProvider.fetchAccountAlertTitle()
        let accountAlertMessage = await contentProvider.fetchAccountAlertMessage()
        let accountAlertPrimaryActionText = await contentProvider.fetchAccountAlertPrimaryActionText()
        let accountAlertSecondaryActionText = await contentProvider.fetchAccountAlertSecondaryActionText()

        return RDAlertModel(title: accountAlertTitle,
                            message: accountAlertMessage,
                            buttons: [
                                RDAlertButtonModel(title: accountAlertPrimaryActionText, action: {}, role: .cancel),
                                RDAlertButtonModel(title: accountAlertSecondaryActionText, action: {
                                    Task {
                                        await self.deleteAccount()
                                    }
                                }, role: .destructive)
                            ])
    }

    private func savePhotoURL(from: Data) {
//        currentUser?.photoURL = displayName
//        await updateUser()
    }

    private func deleteAccount() async {
        authenticationManager.deleteAccount {
            self.shouldReauthenticate = true
        }
    }

    private func deleteUser() async {
        do {
            try await authenticationManager.deleteUser()
        } catch {
            shouldReauthenticate = true
        }
    }

    private func fetchUser() async {
        currentUser = await firebaseProvider?.fetchUser()
    }

    private func updateUser(displayName: String) async {
        currentUser?.displayName = displayName
        await updateUser()
    }

    private func updateUser(photoURL: URL?) async {
        currentUser?.photoURL = photoURL
        await updateUser()
    }

    private func updateUser() async {
        if let currentUser {
            do {
                try await firebaseProvider?.updateUser(with: currentUser)
            } catch {
                //
            }
        }
    }

    func logOut() async {
        await authenticationManager.logOut()
        shouldReauthenticate = false
    }
}
