import Foundation

class AuthenticationFeature<Provider>: Feature where Provider: AuthenticationProvider {
    var featureProvider: any FeatureProvider
    
    init(featureProvider: any FeatureProvider) {
        self.featureProvider = featureProvider
    }

    public var featureView: any FeatureView {
        AuthenticationView(provider: self.featureProvider as! Provider)
    }


}
