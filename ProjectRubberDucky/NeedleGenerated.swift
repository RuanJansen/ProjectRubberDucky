

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
    var userDefaultsManager: UserDefaultsManager {
        return rootComponent.userDefaultsManager
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
private class AccountDependency38402058fc99315b7606Provider: AccountDependency {
    var accountProvider: any FeatureProvider {
        return rootComponent.accountProvider
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->AccountComponent
private func factory67f6ec6b2855db44921ab3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return AccountDependency38402058fc99315b7606Provider(rootComponent: parent1(component) as! RootComponent)
}
private class HomeDependencycad225e9266b3c9a56ddProvider: HomeDependency {
    var homeFeatureProvider: any FeatureProvider {
        return rootComponent.homeFeatureProvider
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
private class SearchDependencyf947dc409bd44ace18e0Provider: SearchDependency {
    var searchFeatureProvider: any FeatureProvider {
        return rootComponent.searchFeatureProvider
    }
    var searchUsecase: SearchUsecase {
        return rootComponent.searchUsecase
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->SearchComponent
private func factory0febe76f0f58b52b4c18b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SearchDependencyf947dc409bd44ace18e0Provider(rootComponent: parent1(component) as! RootComponent)
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
private class FirebaseDependencyaefab86451f384d2bf0bProvider: FirebaseDependency {


    init() {

    }
}
/// ^->RootComponent->FirebaseComponent
private func factory5f1a7b4ee4ee371ff93ae3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return FirebaseDependencyaefab86451f384d2bf0bProvider()
}
private class TabViewContainerDependencyaf64c5e4f995451e1558Provider: TabViewContainerDependency {
    var homeComponent: HomeComponent {
        return rootComponent.homeComponent
    }
    var libraryComponent: LibraryComponent {
        return rootComponent.libraryComponent
    }
    var settingsComponent: SettingsComponent {
        return rootComponent.settingsComponent
    }
    var searchComponent: SearchComponent {
        return rootComponent.searchComponent
    }
    var tabFeatureFlagProvider: TabFeatureFlagProvidable {
        return rootComponent.tabFeatureFlagProvider
    }
    var navigationCoordinator: Coordinator<MainCoordinatorDestination> {
        return rootComponent.navigationCoordinator
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
extension OnboardingComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\OnboardingDependency.onboardingProvider] = "onboardingProvider-any FeatureProvider"
        keyPathToName[\OnboardingDependency.userDefaultsManager] = "userDefaultsManager-UserDefaultsManager"
    }
}
extension AccountComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\AccountDependency.accountProvider] = "accountProvider-any FeatureProvider"
    }
}
extension HomeComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\HomeDependency.homeFeatureProvider] = "homeFeatureProvider-any FeatureProvider"
    }
}
extension SearchComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\SearchDependency.searchFeatureProvider] = "searchFeatureProvider-any FeatureProvider"
        keyPathToName[\SearchDependency.searchUsecase] = "searchUsecase-SearchUsecase"
    }
}
extension SettingsComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\SettingsDependency.settingsFeatureProvider] = "settingsFeatureProvider-any FeatureProvider"
    }
}
extension AuthenticationComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\AuthenticationDependency.authenticationFeatureProvider] = "authenticationFeatureProvider-any FeatureProvider"
        keyPathToName[\AuthenticationDependency.authenticationUsecase] = "authenticationUsecase-AuthenticationUsecase"
    }
}
extension LibraryComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\LibraryDependency.libraryFeatureProvider] = "libraryFeatureProvider-any FeatureProvider"
    }
}
extension FirebaseComponent: NeedleFoundation.Registration {
    public func registerItems() {

    }
}
extension TabViewContainerComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\TabViewContainerDependency.homeComponent] = "homeComponent-HomeComponent"
        keyPathToName[\TabViewContainerDependency.libraryComponent] = "libraryComponent-LibraryComponent"
        keyPathToName[\TabViewContainerDependency.settingsComponent] = "settingsComponent-SettingsComponent"
        keyPathToName[\TabViewContainerDependency.searchComponent] = "searchComponent-SearchComponent"
        keyPathToName[\TabViewContainerDependency.tabFeatureFlagProvider] = "tabFeatureFlagProvider-TabFeatureFlagProvidable"
        keyPathToName[\TabViewContainerDependency.navigationCoordinator] = "navigationCoordinator-Coordinator<MainCoordinatorDestination>"
    }
}
extension RootComponent: NeedleFoundation.Registration {
    public func registerItems() {

        localTable["appStyling-AppStyling"] = { [unowned self] in self.appStyling as Any }
        localTable["appMetaData-AppMetaData"] = { [unowned self] in self.appMetaData as Any }
        localTable["view-some View"] = { [unowned self] in self.view as Any }
        localTable["splashScreen-some View"] = { [unowned self] in self.splashScreen as Any }
        localTable["coordinatorStack-some View"] = { [unowned self] in self.coordinatorStack as Any }
        localTable["navigationCoordinator-Coordinator<MainCoordinatorDestination>"] = { [unowned self] in self.navigationCoordinator as Any }
        localTable["navigationManager-NavigationManager"] = { [unowned self] in self.navigationManager as Any }
        localTable["featureFlagProvider-FeatureFlagProvider"] = { [unowned self] in self.featureFlagProvider as Any }
        localTable["contentFetcher-ContentFetcher"] = { [unowned self] in self.contentFetcher as Any }
        localTable["featureFlagFetcher-FeatureFlagFetcher"] = { [unowned self] in self.featureFlagFetcher as Any }
        localTable["userDefaultsManager-UserDefaultsManager"] = { [unowned self] in self.userDefaultsManager as Any }
        localTable["onboardingComponent-OnboardingComponent"] = { [unowned self] in self.onboardingComponent as Any }
        localTable["accountComponent-AccountComponent"] = { [unowned self] in self.accountComponent as Any }
        localTable["accountProvider-any FeatureProvider"] = { [unowned self] in self.accountProvider as Any }
        localTable["accountContentProvider-AccountContentProvidable"] = { [unowned self] in self.accountContentProvider as Any }
        localTable["homeComponent-HomeComponent"] = { [unowned self] in self.homeComponent as Any }
        localTable["videoRepository-PexelRepository"] = { [unowned self] in self.videoRepository as Any }
        localTable["homeContentProvider-HomeContentProvidable"] = { [unowned self] in self.homeContentProvider as Any }
        localTable["searchComponent-SearchComponent"] = { [unowned self] in self.searchComponent as Any }
        localTable["searchUsecase-SearchUsecase"] = { [unowned self] in self.searchUsecase as Any }
        localTable["settingsComponent-SettingsComponent"] = { [unowned self] in self.settingsComponent as Any }
        localTable["settingsFeatureProvider-any FeatureProvider"] = { [unowned self] in self.settingsFeatureProvider as Any }
        localTable["settingsContentProvider-SettingsContentProvidable"] = { [unowned self] in self.settingsContentProvider as Any }
        localTable["authenticationComponent-AuthenticationComponent"] = { [unowned self] in self.authenticationComponent as Any }
        localTable["authenticationFeatureProvider-any FeatureProvider"] = { [unowned self] in self.authenticationFeatureProvider as Any }
        localTable["authenticationContentProvider-AuthenticationContentProvidable"] = { [unowned self] in self.authenticationContentProvider as Any }
        localTable["authenticationUsecase-AuthenticationUsecase"] = { [unowned self] in self.authenticationUsecase as Any }
        localTable["userAuthenticationManager-UserAuthenticationManager"] = { [unowned self] in self.userAuthenticationManager as Any }
        localTable["appleSignInManager-any AppleSignInManageable"] = { [unowned self] in self.appleSignInManager as Any }
        localTable["emailSignInManager-EmailSignInManageable"] = { [unowned self] in self.emailSignInManager as Any }
        localTable["emailRegistrationManager-EmailRegistrationManageable"] = { [unowned self] in self.emailRegistrationManager as Any }
        localTable["userDeleteManager-UserDeleteManageable"] = { [unowned self] in self.userDeleteManager as Any }
        localTable["userLogoutManager-LogoutManageable"] = { [unowned self] in self.userLogoutManager as Any }
        localTable["libraryComponent-LibraryComponent"] = { [unowned self] in self.libraryComponent as Any }
        localTable["libraryFeatureProvider-any FeatureProvider"] = { [unowned self] in self.libraryFeatureProvider as Any }
        localTable["firebaseComponent-FirebaseComponent"] = { [unowned self] in self.firebaseComponent as Any }
        localTable["tabViewContainerComponent-TabViewContainerComponent"] = { [unowned self] in self.tabViewContainerComponent as Any }
        localTable["tabFeatureFlagProvider-TabFeatureFlagProvidable"] = { [unowned self] in self.tabFeatureFlagProvider as Any }
        localTable["plexComponent-PlexComponent"] = { [unowned self] in self.plexComponent as Any }
        localTable["plexGateway-PlexGateway"] = { [unowned self] in self.plexGateway as Any }
    }
}
extension PlexComponent: NeedleFoundation.Registration {
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
    registerProviderFactory("^->RootComponent->AccountComponent", factory67f6ec6b2855db44921ab3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->HomeComponent", factory7cf6ef49229ffaf97a15b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->SearchComponent", factory0febe76f0f58b52b4c18b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->SettingsComponent", factory3b338491ae548e90be9ab3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->AuthenticationComponent", factorya9615aa036cdc6ec6737b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->LibraryComponent", factorydbcb054e6931f74941b7b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->FirebaseComponent", factory5f1a7b4ee4ee371ff93ae3b0c44298fc1c149afb)
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
