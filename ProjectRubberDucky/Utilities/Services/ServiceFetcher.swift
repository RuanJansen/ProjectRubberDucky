import Foundation

class ServiceFetcher {
    static func fetch<T: Codable>(_ type: T.Type, using domain: String, form path: String, where key: String? = nil) async -> T? where T : Decodable, T : Encodable{
        let url = domain + path
        guard let data = APIFetcher.fetchData(from: url, where: key) else { return nil }
        do {
            let decodedData = try await DataDecoder.decode(data, to: type)
            return decodedData
        } catch {
            return nil
        }
    }
}
