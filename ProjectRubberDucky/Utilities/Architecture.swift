//
//  Architecture.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/23.
//

import Foundation
import SwiftUI

public protocol Tabable: Identifiable, Hashable {
    var id: UUID { get }
    var name: String { get }
    var systemImage: String { get }
    var feature: any Feature { get }
}

public protocol Feature {
    var featureProvider: any FeatureProvider { get }
    var featureView: any FeatureView { get }
}

public protocol FeatureView: View {
    associatedtype Provider

    var provider: Provider { get }
}

public protocol FeatureProvider: AnyObject {
    associatedtype DataModel

    var viewState: ViewState<DataModel> { get set }

    func fetchContent() async
}

public enum ViewState<DataModel> {
    case loading
    case presentContent(using: DataModel)
    case error
    case none
}
