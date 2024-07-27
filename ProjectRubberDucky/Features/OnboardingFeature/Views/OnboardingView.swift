//
//  OnboardingView.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/26.
//

import SwiftUI

struct OnboardingView<Provider: FeatureProvider>: FeatureView where Provider.DataModel == [OnboardingDataModel]{
    @State var provider: Provider
    @State private var onboardingUsecase: OnboardingUsecase

    @Environment(\.dismiss) private var dismiss

    @State var pageIndex: Int = 0

    init(provider: Provider,
         onboardingUsecase: OnboardingUsecase) {
        self.provider =  provider
        self.onboardingUsecase = onboardingUsecase

    }

    var body: some View {
        Group {
            switch provider.viewState {
            case .loading:
                ProgressView()
            case .presentContent(let dataModel):
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
    }

    private func createContentView(using dataModel: [OnboardingDataModel]) -> some View {
        TabView(selection: $pageIndex) {
            ForEach(dataModel, id: \.id) { page in
                createOnboardingPage(page: page, isLastPage: page.id == dataModel.last?.id)
                    .tag(page.tag)
            }
        }
    }

    private func createOnboardingPage(page: OnboardingDataModel, isLastPage: Bool) -> some View {
        VStack(alignment: .center) {
            if let image = page.image {
                image
            }

            Text(page.title)

            Text(page.description)

            Button {
                if isLastPage {
                    onboardingUsecase.isShowingOnboarding.toggle()
                    dismiss()
                } else {
                    pageIndex += 1
                }
            } label: {
                Text(page.buttonTitle)
            }
        }
    }
}
