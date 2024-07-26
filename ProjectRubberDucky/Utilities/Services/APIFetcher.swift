import Foundation

class APIFetcher {
    static func fetchData(httpMethod: String? = nil, body: [String: Any]? = nil, headers: [String: String]? = nil, from url: String) -> Data? {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return nil
        }

        var urlRequest = URLRequest(url: url)

        if let httpMethod {
            urlRequest.httpMethod = httpMethod
        }

        if let headers {
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }

        }

        if let body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Failed to serialize JSON: \(error)")
                return nil
            }
        }

        var responseData: Data?
        let semaphore = DispatchSemaphore(value: 0)

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            defer { semaphore.signal() }

            guard let data else {
                return
            }

            responseData = data
        }.resume()

        semaphore.wait()
        return responseData
    }
}
