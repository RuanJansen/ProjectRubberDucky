//
//  CarouselTemplate.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/09/09.
//

import SwiftUI
import Kingfisher

struct CarouselTemplate: View {
    private var heading: (text: String, destination: AnyView?)?
    private var content: [any CarouselItem]
    private var destination: () -> (AnyView)

    var body: some View {
        VStack {
            if let heading {
                Group {
                    if let destination = heading.destination {
                        RDButton(.navigate(hideChevron: true) {
                            destination
                        }) {
                            Label(heading.text, systemImage: "chevron.right")
                                .environment(\.layoutDirection, .rightToLeft)
                                .font(.title3)
                        }
                    } else {
                        Text(heading.text)
                            .font(.title3)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(content, id: \.id) { item in
                        VStack {
                            RDButton(.navigate(hideChevron: true) {
                                destination()
                            }) {
                                CardView(item: item)
                            }
                            .modifier(CarouselButtonModifier())
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

struct CardView: View {
    private let item: any CarouselItem

    init(item: any CarouselItem) {
        self.item = item
    }

    var body: some View {
        KFImage(item.imageURL)
            .placeholder {
                Image(systemName: "wifi.slash")

            }
            .resizable()
            .scaledToFill()
    }
}
