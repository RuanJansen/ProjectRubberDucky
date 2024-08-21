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

    func fetchContent() async {
        await fetchUser()
        let pageTitle = await contentProvider.fetchPageTitle()
        let alertModel = await setupDeleteAlert()
        let deleteText = await contentProvider.fetchDeleteText()
        let profileImageButtonAction: RDButtonAction = .photosPicker {
            RDPhotosPickerModel()
        } selection: { selection in
            self.photosPickerManager.selection = selection
        }

        await MainActor.run {
            self.viewState = .presentContent(using: AccountDataModel(pageTitle: pageTitle,
                                                                     user: currentUser,
                                                                     profileImageButtonAction: profileImageButtonAction,
                                                                     sections: [SectionDataModel(items: [SectionItemDataModel(title: deleteText,
                                                                                                                              buttonAction: .alert {
                alertModel
            },
                                                                                                                              fontColor: .red,
                                                                                                                              hasMaxWidth: true)])]))
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
                                        self.deleteAccount()
                                }, role: .destructive)
                            ])
    }

    private func savePhotoURL(from: Data) {
//        currentUser?.photoURL = displayName
//        await updateUser()
    }

    private func deleteAccount() {
        authenticationManager.deleteUser()
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
}
