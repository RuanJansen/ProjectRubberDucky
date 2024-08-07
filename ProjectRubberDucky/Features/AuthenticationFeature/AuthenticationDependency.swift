import NeedleFoundation

protocol AuthenticationDependency: Dependency {
    var authenticationFeatureProvider: any FeatureProvider { get }
    var authenticationUsecase: AuthenticationUsecase { get }
}
