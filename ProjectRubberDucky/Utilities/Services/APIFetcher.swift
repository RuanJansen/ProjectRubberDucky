import Foundation

class APIFetcher {
    static func fetchData(using headers: [String: String]? = nil, from url: String) -> Data? {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return nil
        }

        var urlRequest = URLRequest(url: url)

        if let headers {
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
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
