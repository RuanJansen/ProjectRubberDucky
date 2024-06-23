import Foundation

class DataDecoder {
    static func decode<T: Codable>(_ data: Data, to modelType: T.Type) async throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        }
    }
}
