import Foundation
import NeedleFoundation
import SwiftUI

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class TabViewContainerDependencyaf64c5e4f995451e1558Provider: TabViewContainerDependency {
    var videoPlayerComponent: VideoPlayerComponent {
        return rootComponent.videoPlayerComponent
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->TabViewContainerComponent
private func factoryf4fcb82992c91b07199cb3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return TabViewContainerDependencyaf64c5e4f995451e1558Provider(rootComponent: parent1(component) as! RootComponent)
}
private class VideoPlayerDependencyd49b6dd1dd1945906ac2Provider: VideoPlayerDependency {
    var videoPlayerFeatureProvider: any FeatureProvider {
        return rootComponent.videoPlayerFeatureProvider
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->StratagemComponent
private func factorya3887b63d4de1343e242b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return VideoPlayerDependencyd49b6dd1dd1945906ac2Provider(rootComponent: parent1(component) as! RootComponent)
}

#else
extension TabViewContainerComponent: Registration {
    public func registerItems() {
        keyPathToName[\TabViewContainerDependency.videoPlayerComponent] = "videoPlayerComponent-VideoPlayerComponent"
    }
}
extension StratagemComponent: Registration {
    public func registerItems() {
        keyPathToName[\VideoPlayerDependency.videoPlayerFeatureProvider] = "videoPlayerFeatureProvider-any FeatureProvider"
    }
}
extension RootComponent: Registration {
    public func registerItems() {

        localTable["view-some View"] = { [unowned self] in self.view as Any }
        localTable["tabViewContainerComponent-TabViewContainerComponent"] = { [unowned self] in self.tabViewContainerComponent as Any }
        localTable["videoPlayerComponent-VideoPlayerComponent"] = { [unowned self] in self.videoPlayerComponent as Any }
        localTable["videoPlayerFeatureProvider-any FeatureProvider"] = { [unowned self] in self.videoPlayerFeatureProvider as Any }
        localTable["videoRepository-VideoRepository"] = { [unowned self] in self.videoRepository as Any }
    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->RootComponent->TabViewContainerComponent", factoryf4fcb82992c91b07199cb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->VideoPlayerComponent", factorya3887b63d4de1343e242b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
