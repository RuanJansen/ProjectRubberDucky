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

    private var authenticationManager: AuthenticationManager
    private var firebaseProvider: FirebaseProvider?
    private var photosPickerUsecase: PhotosPickerUsecase

    private var currentUser: UserAuthDataModel?

    private var cancellables = Set<AnyCancellable>()

    init(authenticationManager: AuthenticationManager,
         firebaseProvider: FirebaseProvider?) {
        self.viewState = .loading
        self.authenticationManager = authenticationManager
        self.firebaseProvider = firebaseProvider
        self.photosPickerUsecase = PhotosPickerUsecase()
    }

    func addListeners() {
        photosPickerUsecase.$selection.sink { selection in
            Task {
                do {
                    if let data = try await self.photosPickerUsecase.fetchImageData() {
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
        let alertModel = await setupDeleteAlert()
        await MainActor.run {
            self.viewState = .presentContent(using: AccountDataModel(user: currentUser,
//                                                                     profileImageButtonAction: .photosPicker {
//                RDPhotosPickerModel(selection: self.photosPickerUsecase.selection)
//            } ,
                                                                     sections: [SectionDataModel(items: [SectionItemDataModel(title: "Delete Account",
                                                                                                                              buttonAction: .alert{
                alertModel
            },
                                                                                                                              fontColor: .red,
                                                                                                                              hasMaxWidth: true)])]))
        }
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

    private func savePhotoURL(from: Data) {

    }

    private func deleteAccount() async {
        await authenticationManager.deleteAccount()
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
