//
//  AppStyling.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import SwiftUI

@Observable
class AppStyling {
    let appName = "Film Factory"
    let appIconImage = Image(uiImage: Bundle.main.icon!)
    let tintColor = Color("AppTint")
    let appBackgroundColor = Color("AppBackground")
}

extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}
