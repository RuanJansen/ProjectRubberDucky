import Foundation

struct AuthenticationDataModel {
    let title: String
}

struct AuthenticationSection: Identifiable {
    let id: UUID

    let header: String
    let textfield: String
    
}
