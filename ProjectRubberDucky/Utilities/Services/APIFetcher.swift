import Foundation

class APIFetcher {
    static func fetchData(from url: String) -> Data? {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return nil
        }

        var responseData: Data?
        let semaphore = DispatchSemaphore(value: 0)

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { semaphore.signal() }

            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }

            guard let data else {
                print("No data received")
                return
            }

            responseData = data
        }.resume()

        semaphore.wait()
        return responseData
    }
}
