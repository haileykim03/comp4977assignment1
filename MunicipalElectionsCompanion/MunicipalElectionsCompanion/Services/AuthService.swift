import Foundation
import FirebaseAuth

enum AuthService {
    static let tokenKey = "jwt"

    static func login(email: String, password: String) async throws -> LoginResponse {
        let body = try JSONEncoder().encode(LoginRequest(email: email, password: password))
        let data = try await APIService.send("/auth/login", method: "POST", body: body, requiresAuth: false)
        do {
            return try JSONDecoder().decode(LoginResponse.self, from: data)
        } catch {
            throw APIError.invalidResponse
        }
    }

    static func register(name: String, email: String, password: String) async throws {
        let body = try JSONEncoder().encode(RegisterRequest(name: name, email: email, password: password))
        _ = try await APIService.send("/auth/register", method: "POST", body: body, requiresAuth: false)
    }

    static func me() async throws -> MeResponse {
        try await APIService.get(MeResponse.self, from: "/auth/me")
    }

    static func savedToken() -> String? {
        KeychainService.read(tokenKey)
    }

    static func saveToken(_ token: String) {
        KeychainService.save(token, for: tokenKey)
    }

    static func deleteToken() {
        KeychainService.delete(tokenKey)
    }

    static func isExpired(_ token: String) -> Bool {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else {
            return true
        }

        var payload = String(parts[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while payload.count % 4 != 0 {
            payload += "="
        }

        guard let data = Data(base64Encoded: payload),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let exp = json["exp"] as? Double else {
            return true
        }

        return Date(timeIntervalSince1970: exp) <= Date()
    }

    static func signInToFirebase(email: String, password: String) async throws {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            if AuthErrorCode(rawValue: (error as NSError).code) == .networkError {
                throw error
            }
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
        }
    }

    static var firebaseEmail: String? {
        Auth.auth().currentUser?.email
    }

    static func isFirebaseSignedIn(as email: String) -> Bool {
        guard let current = firebaseEmail else {
            return false
        }
        return current.lowercased() == email.lowercased()
    }

    static func signOutOfFirebase() {
        try? Auth.auth().signOut()
    }
}
