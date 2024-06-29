import Foundation

class APIFetcher {
    static func fetchData(from url: String, where key: String? = nil) -> Data? {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return nil
        }

        var urlRequest = URLRequest(url: url)
        if let key {
            urlRequest.setValue(key, forHTTPHeaderField: "Authorization")
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
