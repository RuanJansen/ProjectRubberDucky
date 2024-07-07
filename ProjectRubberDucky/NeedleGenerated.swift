

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

private class VideoPlayerDependency3bd39f7301b443c46ea0Provider: VideoPlayerDependency {
    var videoPlayerFeatureProvider: any FeatureProvider {
        return rootComponent.videoPlayerFeatureProvider
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->VideoPlayerComponent
private func factory232adfb6564890b636e6b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return VideoPlayerDependency3bd39f7301b443c46ea0Provider(rootComponent: parent1(component) as! RootComponent)
}
private class AuthenticationDependencyc2b4de2bfc19a7d065eeProvider: AuthenticationDependency {
    var authenticationFeatureProvider: any FeatureProvider {
        return rootComponent.authenticationFeatureProvider
    }
    var authenticationUsecase: AuthenticationUsecase {
        return rootComponent.authenticationUsecase
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->AuthenticationComponent
private func factorya9615aa036cdc6ec6737b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return AuthenticationDependencyc2b4de2bfc19a7d065eeProvider(rootComponent: parent1(component) as! RootComponent)
}
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
private class PlexDependency0f97827058ae2b890713Provider: PlexDependency {
    var plexGateway: PlexGateway {
        return rootComponent.plexGateway
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->PlexComponent
private func factory76e860a0d75736e01a13b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PlexDependency0f97827058ae2b890713Provider(rootComponent: parent1(component) as! RootComponent)
}

#else
extension RootComponent: Registration {
    public func registerItems() {

        localTable["view-some View"] = { [unowned self] in self.view as Any }
        localTable["videoPlayerComponent-VideoPlayerComponent"] = { [unowned self] in self.videoPlayerComponent as Any }
        localTable["videoPlayerFeatureProvider-any FeatureProvider"] = { [unowned self] in self.videoPlayerFeatureProvider as Any }
        localTable["videoRepository-VideoRepository"] = { [unowned self] in self.videoRepository as Any }
        localTable["authenticationComponent-AuthenticationComponent"] = { [unowned self] in self.authenticationComponent as Any }
        localTable["authenticationFeatureProvider-any FeatureProvider"] = { [unowned self] in self.authenticationFeatureProvider as Any }
        localTable["authenticationManager-AuthenticationManager"] = { [unowned self] in self.authenticationManager as Any }
        localTable["authenticationUsecase-AuthenticationUsecase"] = { [unowned self] in self.authenticationUsecase as Any }
        localTable["tabViewContainerComponent-TabViewContainerComponent"] = { [unowned self] in self.tabViewContainerComponent as Any }
        localTable["plexComponent-PlexComponent"] = { [unowned self] in self.plexComponent as Any }
        localTable["plexGateway-PlexGateway"] = { [unowned self] in self.plexGateway as Any }
    }
}
extension VideoPlayerComponent: Registration {
    public func registerItems() {
        keyPathToName[\VideoPlayerDependency.videoPlayerFeatureProvider] = "videoPlayerFeatureProvider-any FeatureProvider"
    }
}
extension AuthenticationComponent: Registration {
    public func registerItems() {
        keyPathToName[\AuthenticationDependency.authenticationFeatureProvider] = "authenticationFeatureProvider-any FeatureProvider"
        keyPathToName[\AuthenticationDependency.authenticationUsecase] = "authenticationUsecase-AuthenticationUsecase"
    }
}
extension TabViewContainerComponent: Registration {
    public func registerItems() {
        keyPathToName[\TabViewContainerDependency.videoPlayerComponent] = "videoPlayerComponent-VideoPlayerComponent"
    }
}
extension PlexComponent: Registration {
    public func registerItems() {
        keyPathToName[\PlexDependency.plexGateway] = "plexGateway-PlexGateway"
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
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->RootComponent->VideoPlayerComponent", factory232adfb6564890b636e6b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->AuthenticationComponent", factorya9615aa036cdc6ec6737b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->TabViewContainerComponent", factoryf4fcb82992c91b07199cb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->PlexComponent", factory76e860a0d75736e01a13b3a8f24c1d289f2c0f2e)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
