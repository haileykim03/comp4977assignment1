import Foundation

enum APIError: LocalizedError {
    case unauthorized
    case network(String)
    case server(String)
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .network(let message), .server(let message):
            return message
        case .invalidResponse:
            return "The server sent data the app could not read. Please try again later."
        }
    }
}

class APIService {
    static let baseURL = "https://mems-api-assignment-dceshuhtebhmc9d9.westus-01.azurewebsites.net/api"

    static var onUnauthorized: (() -> Void)?

    static func send(_ path: String,
                     method: String = "GET",
                     query: [String: String] = [:],
                     body: Data? = nil,
                     requiresAuth: Bool = true) async throws -> Data {
        guard var components = URLComponents(string: baseURL + path) else {
            throw APIError.invalidResponse
        }
        if !query.isEmpty {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components.url else {
            throw APIError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 60
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        if requiresAuth {
            guard let token = AuthService.savedToken(), !AuthService.isExpired(token) else {
                onUnauthorized?()
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let result: (Data, URLResponse)
        do {
            result = try await URLSession.shared.data(for: request)
        } catch let error as URLError {
            if error.code == .cancelled {
                throw CancellationError()
            }
            throw APIError.network(networkMessage(for: error))
        }
        let (data, response) = result

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if httpResponse.statusCode == 401 && requiresAuth {
            onUnauthorized?()
            throw APIError.unauthorized
        }

        if httpResponse.statusCode >= 400 {
            var message = "Request failed (error \(httpResponse.statusCode))."
            if let error = try? JSONDecoder().decode(MessageResponse.self, from: data) {
                message = error.message
            }
            throw APIError.server(message)
        }

        return data
    }

    static func get<T: Decodable>(_ type: T.Type,
                                  from path: String,
                                  query: [String: String] = [:],
                                  requiresAuth: Bool = true) async throws -> T {
        let data = try await send(path, query: query, requiresAuth: requiresAuth)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.invalidResponse
        }
    }

    private static func networkMessage(for error: URLError) -> String {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            return "You appear to be offline. Check your internet connection and try again."
        case .timedOut:
            return "The server took too long to respond. It may be starting up - please try again."
        case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
            return "Could not reach the election server. Please try again later."
        default:
            return "A network error occurred: \(error.localizedDescription)"
        }
    }
}
