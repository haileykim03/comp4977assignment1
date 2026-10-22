import Foundation

// Handles every call to our ASP.NET Web API (URLSession + async/await)
class APIService {
    // Address of the API deployed on Azure
    static let baseURL = "https://mems-api-assignment-dceshuhtebhmc9d9.westus-01.azurewebsites.net/api"

    // Sends a request to the API and returns the JSON data
    static func send(_ path: String, method: String = "GET", body: Data? = nil, token: String? = nil) async throws -> Data {
        var request = URLRequest(url: URL(string: baseURL + path)!)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        // Protected endpoints need the JWT token
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Network errors (e.g. no internet) are thrown here
        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as! HTTPURLResponse).statusCode

        // API errors: our API sends { "message": "..." }
        if statusCode >= 400 {
            var message = "Request failed (error \(statusCode))."
            if statusCode == 401 {
                message = "Please log in again."
            }
            if let error = try? JSONDecoder().decode(MessageResponse.self, from: data) {
                message = error.message
            }
            throw NSError(domain: "API", code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
        }

        return data
    }
}
