//
//  AccountComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import Foundation
import NeedleFoundation

class AccountComponent: Component<AccountDependency> {

    public var feature: any Feature {
        AccountFeature(featureProvider: featureProvider)
    }

    public var featureProvider: any FeatureProvider {
        dependency.accountProvider
    }
}
