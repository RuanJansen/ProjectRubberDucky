//
//  RDButtonView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI
import PhotosUI

struct RDButton<Label> : View where Label : View{
    let action: RDButtonAction
    let label: () -> Label

    init(_ action: RDButtonAction,
         label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    @State private var destination: AnyView?

    @State private var presentSheet: Bool = false

    @State private var navigate: Bool = false

    @State private var fullScreenCoverSwipeDismissable: Bool = false
    @State private var fullScreenCover: Bool = false

    @State private var alertModel: RDAlertModel?
    @State private var showAlert: Bool = false

    @State private var photosPickerModel: RDPhotosPickerModel?
    @State private var photosPicker: Bool = false

    var body: some View {
        Button {
            switch action {
            case .action(let action):
                action()
            case .sheet(let view):
                destination = view()
                presentSheet = true
            case .navigate(_, let view):
                destination = view()
                navigate = true
            case .alert(let model):
                alertModel = model()
                showAlert = true
            case .fullScreenCover(let swipeDismissable, let view):
                destination = view()
                fullScreenCover = true
                fullScreenCoverSwipeDismissable = swipeDismissable
            case .photosPicker(let model):
                photosPickerModel = model()
                photosPicker = true
            case .none: break
                //
            }
        } label: {
            switch action {
            case .action( _):
                label()
            case .sheet(let anyView):
                label()
            case .navigate(let hideChevron, _):
                if hideChevron {
                    label()
                } else {
                    HStack {
                        label()
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.tertiary)
                    }
                }
            case .alert(_):
                label()
            case .fullScreenCover(_):
                label()
            case .photosPicker(_):
                label()
            case .none:
                label()
            }
        }
        .sheet(isPresented: $presentSheet) {
            if let destination {
                destination
            }
        }
        .navigationDestination(isPresented: $navigate) {
            if let destination {
                destination
            }
        }
        .fullScreenCover(isPresented: $fullScreenCover) {
            if let destination {
                destination
                    .if(fullScreenCoverSwipeDismissable) { view in
                            view
                            .gesture(
                                DragGesture().onEnded { value in
                                    if value.location.y - value.startLocation.y > 150 {
                                        fullScreenCover = false
                                    }
                                }
                            )
                    }
            }
        }
        .alert(alertModel?.title ?? "",
               isPresented: $showAlert, actions: {
            if let buttons = alertModel?.buttons {
                ForEach(buttons, id: \.id) { button in
                    Button(role: button.role) {
                        button.action()
                    } label: {
                        Text(button.title)
                    }
                }
            }
        }, message: {
            if let message = alertModel?.message {
                Text(message)
            }
        })
        .if(photosPicker) { view in
            if let photosPickerModel {
                view
                    .photosPicker(isPresented: $photosPicker,
                                  selection: photosPickerModel.$selection,
                                  matching: photosPickerModel.matching,
                                  preferredItemEncoding: photosPickerModel.preferredItemEncoding)
            }
        }

    }
}

enum RDButtonAction {
    case action(() -> Void)
    case sheet(() -> AnyView)
    case navigate(hideChevron: Bool = false, () -> AnyView)
    case fullScreenCover(swipeDismissable: Bool = false,() -> AnyView)
    case alert(() -> RDAlertModel)
    case photosPicker(() -> RDPhotosPickerModel)
    case none
}

struct RDAlertModel {
    let title: String
    let message: String?
    let buttons: [RDAlertButtonModel]
}

struct RDAlertButtonModel {
    let id: UUID
    let title: String
    let action: () -> Void
    let role: ButtonRole?

    init(title: String, action: @escaping () -> Void, role: ButtonRole? = nil) {
        self.id = UUID()
        self.title = title
        self.action = action
        self.role = role
    }
}

struct RDPhotosPickerModel {
    @State var selection: PhotosPickerItem?
    let matching: PHPickerFilter
    let preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy

    init(selection: PhotosPickerItem?,
         matching: PHPickerFilter = .images,
         preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic) {
        self._selection = State(initialValue: selection)
        self.matching = matching
        self.preferredItemEncoding = preferredItemEncoding
    }
}

