//
//  LibraryComponent.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/05.
//

import NeedleFoundation

extension RootComponent {
    public var libraryComponent: LibraryComponent {
        LibraryComponent(parent: self)
    }
    
    public var libraryFeatureProvider: any FeatureProvider {
        LibraryProvider()
    }
}

class LibraryComponent: Component<LibraryDependency> {

    public var feature: any Feature {
        LibraryFeature(featureProvider: featureProvider)
    }

    public var featureProvider: any FeatureProvider {
        dependency.libraryFeatureProvider
    }
}

