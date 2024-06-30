//
//  CarouselButtonModifier.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/30.
//

import Foundation
import SwiftUI

struct CarouselButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .frame(width: 350, height: 175)
    }
}
