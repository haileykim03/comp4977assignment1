import Foundation
import Combine

// Shared login state for the whole app (ObservableObject + @Published, used with .environmentObject)
class AuthViewModel: ObservableObject {
    // JWT token storage: saved in UserDefaults so the user stays logged in
    @Published var token: String? = UserDefaults.standard.string(forKey: "token")
    @Published var name: String = UserDefaults.standard.string(forKey: "name") ?? ""
    @Published var email: String = UserDefaults.standard.string(forKey: "email") ?? ""

    // POST /api/auth/login
    func login(email: String, password: String) async throws {
        // Convert the Swift struct to JSON for the request body
        let body = try JSONEncoder().encode(LoginRequest(email: email, password: password))
        let data = try await APIService.send("/auth/login", method: "POST", body: body)
        let result = try JSONDecoder().decode(LoginResponse.self, from: data)

        token = result.token
        name = result.name ?? ""
        self.email = result.email ?? email

        // Keep the user logged in after the app is closed
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(self.email, forKey: "email")
    }

    // POST /api/auth/register
    func register(name: String, email: String, password: String) async throws {
        let body = try JSONEncoder().encode(RegisterRequest(name: name, email: email, password: password))
        _ = try await APIService.send("/auth/register", method: "POST", body: body)

        // Log in right after the account is created
        try await login(email: email, password: password)
    }

    // Clear the token - ContentView then shows the login screen again
    func logout() {
        token = nil
        name = ""
        email = ""
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "email")
    }

    // Returns an error message, or nil when the form is valid
    func validate(name: String? = nil, email: String, password: String) -> String? {
        if name?.isEmpty == true || email.isEmpty || password.isEmpty {
            return "Please fill in all fields."
        }
        if !email.contains("@") || !email.contains(".") {
            return "Please enter a valid email address."
        }
        if password.count < 6 {
            return "Password must be at least 6 characters."
        }
        return nil
    }
}
