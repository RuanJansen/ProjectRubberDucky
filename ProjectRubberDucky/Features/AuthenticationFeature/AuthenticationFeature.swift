import Foundation

class AuthenticationFeature<Provider>: Feature where Provider: AuthenticationProvider {
    var featureProvider: any FeatureProvider
    var authenticationUsecase: AuthenticationUsecase

    init(featureProvider: any FeatureProvider,
         authenticationUsecase: AuthenticationUsecase) {
        self.featureProvider = featureProvider
        self.authenticationUsecase = authenticationUsecase
    }

    public var featureView: any FeatureView {
        AuthenticationView(provider: self.featureProvider as! Provider,
                           authenticationUsecase: self.authenticationUsecase)
    }
}
