

import Combine
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

private class OnboardingDependencyc2e150944dc3c9e77b26Provider: OnboardingDependency {
    var onboardingProvider: any FeatureProvider {
        return rootComponent.onboardingProvider
    }
    var onboardingUsecase: OnboardingUsecase {
        return rootComponent.onboardingUsecase
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->OnboardingComponent
private func factory8fb7918b43e15c3c3f86b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return OnboardingDependencyc2e150944dc3c9e77b26Provider(rootComponent: parent1(component) as! RootComponent)
}
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
private class HomeDependencycad225e9266b3c9a56ddProvider: HomeDependency {
    var homeFeatureProvider: any FeatureProvider {
        return rootComponent.homeFeatureProvider
    }
    var searchUsecase: SearchUsecase {
        return rootComponent.searchUsecase
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->HomeComponent
private func factory7cf6ef49229ffaf97a15b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return HomeDependencycad225e9266b3c9a56ddProvider(rootComponent: parent1(component) as! RootComponent)
}
private class SubscribedDependencyace226668fff7e031d51Provider: SubscribedDependency {
    var subscribedFeatureProvider: any FeatureProvider {
        return rootComponent.subscribedFeatureProvider
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->SubscribedComponent
private func factoryc31a694f6a52c67c30e7b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SubscribedDependencyace226668fff7e031d51Provider(rootComponent: parent1(component) as! RootComponent)
}
private class SettingsDependency1ba9e199f1bddeac9850Provider: SettingsDependency {
    var settingsFeatureProvider: any FeatureProvider {
        return rootComponent.settingsFeatureProvider
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->SettingsComponent
private func factory3b338491ae548e90be9ab3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SettingsDependency1ba9e199f1bddeac9850Provider(rootComponent: parent1(component) as! RootComponent)
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
private class LibraryDependencydf4b476f51ad8d19a376Provider: LibraryDependency {
    var libraryFeatureProvider: any FeatureProvider {
        return rootComponent.libraryFeatureProvider
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->LibraryComponent
private func factorydbcb054e6931f74941b7b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return LibraryDependencydf4b476f51ad8d19a376Provider(rootComponent: parent1(component) as! RootComponent)
}
private class TabViewContainerDependencyaf64c5e4f995451e1558Provider: TabViewContainerDependency {
    var videoPlayerComponent: VideoPlayerComponent {
        return rootComponent.videoPlayerComponent
    }
    var homeComponent: HomeComponent {
        return rootComponent.homeComponent
    }
    var subscribedComponent: SubscribedComponent {
        return rootComponent.subscribedComponent
    }
    var libraryComponent: LibraryComponent {
        return rootComponent.libraryComponent
    }
    var settingsComponent: SettingsComponent {
        return rootComponent.settingsComponent
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
extension OnboardingComponent: Registration {
    public func registerItems() {
        keyPathToName[\OnboardingDependency.onboardingProvider] = "onboardingProvider-any FeatureProvider"
        keyPathToName[\OnboardingDependency.onboardingUsecase] = "onboardingUsecase-OnboardingUsecase"
    }
}
extension VideoPlayerComponent: Registration {
    public func registerItems() {
        keyPathToName[\VideoPlayerDependency.videoPlayerFeatureProvider] = "videoPlayerFeatureProvider-any FeatureProvider"
    }
}
extension HomeComponent: Registration {
    public func registerItems() {
        keyPathToName[\HomeDependency.homeFeatureProvider] = "homeFeatureProvider-any FeatureProvider"
        keyPathToName[\HomeDependency.searchUsecase] = "searchUsecase-SearchUsecase"
    }
}
extension SubscribedComponent: Registration {
    public func registerItems() {
        keyPathToName[\SubscribedDependency.subscribedFeatureProvider] = "subscribedFeatureProvider-any FeatureProvider"
    }
}
extension SettingsComponent: Registration {
    public func registerItems() {
        keyPathToName[\SettingsDependency.settingsFeatureProvider] = "settingsFeatureProvider-any FeatureProvider"
    }
}
extension AuthenticationComponent: Registration {
    public func registerItems() {
        keyPathToName[\AuthenticationDependency.authenticationFeatureProvider] = "authenticationFeatureProvider-any FeatureProvider"
        keyPathToName[\AuthenticationDependency.authenticationUsecase] = "authenticationUsecase-AuthenticationUsecase"
    }
}
extension LibraryComponent: Registration {
    public func registerItems() {
        keyPathToName[\LibraryDependency.libraryFeatureProvider] = "libraryFeatureProvider-any FeatureProvider"
    }
}
extension TabViewContainerComponent: Registration {
    public func registerItems() {
        keyPathToName[\TabViewContainerDependency.videoPlayerComponent] = "videoPlayerComponent-VideoPlayerComponent"
        keyPathToName[\TabViewContainerDependency.homeComponent] = "homeComponent-HomeComponent"
        keyPathToName[\TabViewContainerDependency.subscribedComponent] = "subscribedComponent-SubscribedComponent"
        keyPathToName[\TabViewContainerDependency.libraryComponent] = "libraryComponent-LibraryComponent"
        keyPathToName[\TabViewContainerDependency.settingsComponent] = "settingsComponent-SettingsComponent"
    }
}
extension RootComponent: Registration {
    public func registerItems() {

        localTable["appStyling-AppStyling"] = { [unowned self] in self.appStyling as Any }
        localTable["appMetaData-AppMetaData"] = { [unowned self] in self.appMetaData as Any }
        localTable["navigationManager-NavigationManager"] = { [unowned self] in self.navigationManager as Any }
        localTable["view-some View"] = { [unowned self] in self.view as Any }
        localTable["onboardingComponent-OnboardingComponent"] = { [unowned self] in self.onboardingComponent as Any }
        localTable["onboardingUsecase-OnboardingUsecase"] = { [unowned self] in self.onboardingUsecase as Any }
        localTable["videoPlayerComponent-VideoPlayerComponent"] = { [unowned self] in self.videoPlayerComponent as Any }
        localTable["videoPlayerFeatureProvider-any FeatureProvider"] = { [unowned self] in self.videoPlayerFeatureProvider as Any }
        localTable["homeComponent-HomeComponent"] = { [unowned self] in self.homeComponent as Any }
        localTable["searchUsecase-SearchUsecase"] = { [unowned self] in self.searchUsecase as Any }
        localTable["videoRepository-PexelRepository"] = { [unowned self] in self.videoRepository as Any }
        localTable["subscribedComponent-SubscribedComponent"] = { [unowned self] in self.subscribedComponent as Any }
        localTable["subscribedFeatureProvider-any FeatureProvider"] = { [unowned self] in self.subscribedFeatureProvider as Any }
        localTable["settingsComponent-SettingsComponent"] = { [unowned self] in self.settingsComponent as Any }
        localTable["settingsFeatureProvider-any FeatureProvider"] = { [unowned self] in self.settingsFeatureProvider as Any }
        localTable["authenticationComponent-AuthenticationComponent"] = { [unowned self] in self.authenticationComponent as Any }
        localTable["authenticationFeatureProvider-any FeatureProvider"] = { [unowned self] in self.authenticationFeatureProvider as Any }
        localTable["authenticationManager-AuthenticationManager"] = { [unowned self] in self.authenticationManager as Any }
        localTable["firebaseAuthenticationManager-FirebaseAuthenticationManager"] = { [unowned self] in self.firebaseAuthenticationManager as Any }
        localTable["authenticationUsecase-AuthenticationUsecase"] = { [unowned self] in self.authenticationUsecase as Any }
        localTable["libraryComponent-LibraryComponent"] = { [unowned self] in self.libraryComponent as Any }
        localTable["libraryFeatureProvider-any FeatureProvider"] = { [unowned self] in self.libraryFeatureProvider as Any }
        localTable["tabViewContainerComponent-TabViewContainerComponent"] = { [unowned self] in self.tabViewContainerComponent as Any }
        localTable["plexComponent-PlexComponent"] = { [unowned self] in self.plexComponent as Any }
        localTable["plexGateway-PlexGateway"] = { [unowned self] in self.plexGateway as Any }
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
    registerProviderFactory("^->RootComponent->OnboardingComponent", factory8fb7918b43e15c3c3f86b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->VideoPlayerComponent", factory232adfb6564890b636e6b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->HomeComponent", factory7cf6ef49229ffaf97a15b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->SubscribedComponent", factoryc31a694f6a52c67c30e7b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->SettingsComponent", factory3b338491ae548e90be9ab3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->AuthenticationComponent", factorya9615aa036cdc6ec6737b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->LibraryComponent", factorydbcb054e6931f74941b7b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->TabViewContainerComponent", factoryf4fcb82992c91b07199cb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->RootComponent->PlexComponent", factory76e860a0d75736e01a13b3a8f24c1d289f2c0f2e)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
