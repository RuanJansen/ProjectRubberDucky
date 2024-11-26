//
//  OnboardingView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import SwiftUI

struct OnboardingView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == [OnboardingDataModel]{
    @State var provider: Provider
    @State private var userDefaultsManager: UserDefaultsManager

    @Environment(\.dismiss) private var dismiss
    @Environment(AppStyling.self) var appStyling

    @State var pageIndex: Int = 0

    init(provider: Provider,
         userDefaultsManager: UserDefaultsManager) {
        self.provider =  provider
        self.userDefaultsManager = userDefaultsManager

    }

    var body: some View {
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presenting(let dataModel):
                createContentView(using: dataModel)
            case .error:
                EmptyView()
            case .none:
                EmptyView()
            }
        }
        .task {
            await provider.fetchContent()
        }
        .tint(appStyling.tintColor)
    }

    private func createContentView(using dataModel: [OnboardingDataModel]) -> some View {
        TabView(selection: $pageIndex) {
            ForEach(dataModel, id: \.id) { page in
                createOnboardingPage(using: dataModel, page: page, isLastPage: page.id == dataModel.last?.id)
                    .tag(page.tag)

            }
        }
    }

    private func createOnboardingPage(using dataModel: [OnboardingDataModel], page: OnboardingDataModel, isLastPage: Bool) -> some View {
        VStack(alignment: .center) {
            HStack {
                ForEach(dataModel, id: \.id) { pageCounter in
                    Circle()
                        .fill(pageCounter.id == page.id ? appStyling.tintColor : Color.white)
                        .frame(width: 5, height: 5)
                }
            }

            Spacer()

            Text(page.title)
                .font(.title2)

            if let image = page.image {
                image
                    .font(.largeTitle)
                    .foregroundStyle(appStyling.tintColor)
                    .padding()

            }

            Text(page.description)
                .multilineTextAlignment(.center)

            Spacer()

            Button {
                if isLastPage {
                    userDefaultsManager.shouldShowOnboarding.toggle()
                    dismiss()
                } else {
                    pageIndex += 1
                }
            } label: {
                Text(page.buttonTitle)
            }
        }
        .padding()
    }
}
