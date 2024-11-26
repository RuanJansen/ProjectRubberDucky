//
//  AccountDependency.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import NeedleFoundation

protocol AccountDependency: Dependency {
    var accountProvider: any FeatureProvider { get }
}

extension RootComponent {
    public var accountComponent: AccountComponent {
        AccountComponent(parent: self)
    }

    public var accountProvider: any FeatureProvider {
        shared {
            AccountProvider(contentProvider: accountContentProvider,
                            userDeleteManager: userDeleteManager,
                            userLogoutManager: userLogoutManager,
                            firebaseUserAuthenticationManager: firebaseComponent.firebaseAuthenticationManager)
        }
    }

    public var accountContentProvider: AccountContentProvidable {
        AccountContentProvider(contentFetcher: contentFetcher)
    }
}
