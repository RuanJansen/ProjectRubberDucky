//
//  LibraryDependency.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import NeedleFoundation

protocol LibraryDependency: Dependency {
    var libraryFeatureProvider: any FeatureProvider { get }
}

extension RootComponent {
    public var libraryComponent: LibraryComponent {
        LibraryComponent(parent: self)
    }

    public var libraryFeatureProvider: any FeatureProvider {
        shared {
            LibraryProvider()
        }
    }
}
