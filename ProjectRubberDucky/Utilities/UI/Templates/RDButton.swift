//
//  RDButtonView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

struct RDButton<Label> : View where Label : View{
    let action: RDButtonAction
    let label: () -> Label

    @State var presentSheet: Bool = false
    @State var navigate: Bool = false
    @State var fullScreenCover: Bool = false
    @State var destination: AnyView?

    @State var alertModel: RDAlertModel?
    @State var showAlert: Bool = false

    var body: some View {
        Button {
            switch action {
            case .action(let action):
                action()
            case .sheet(let view):
                destination = view
                presentSheet = true
            case .navigatate(let view, _):
                destination = view
                navigate = true
            case .alert(let model):
                alertModel = model
                showAlert = true
            case .fullScreenCover(let view):
                destination = view
                fullScreenCover = true
            case .none: break
                //
            }
        } label: {
            switch action {
            case .action( _):
                label()
            case .sheet(let anyView):
                label()
            case .navigatate( _, let hideCevron):
                if hideCevron {
                    label()
                } else {
                    HStack {
                        label()
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.tertiary)
                    }
                }
            case .alert(let model):
                label()
            case .fullScreenCover(_):
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
    }
}

enum RDButtonAction {
    case action(() -> Void)
    case sheet(AnyView)
    case navigatate(AnyView, hideCevron: Bool = false)
    case fullScreenCover(AnyView)
    case alert(RDAlertModel)
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

