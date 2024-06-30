import SwiftUI

struct FocusButtonStyle: ButtonStyle {
    @Environment(\.isFocused) var focused: Bool
    var action: (() -> Void)?

    init(action: (() -> Void)? = nil) {
        self.action = action
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .foregroundStyle(.blue)
            .onChange(of: focused) { oldValue, newValue in
                action?()
            }
    }
}
