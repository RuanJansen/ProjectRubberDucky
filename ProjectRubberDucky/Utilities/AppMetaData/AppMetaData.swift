//
//  AppMetaData.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import Observation
import Foundation

@Observable
class AppMetaData {
    let appVersion = Bundle.main.releaseVersionNumber
    let appBuild = Bundle.main.buildVersionNumber
}
