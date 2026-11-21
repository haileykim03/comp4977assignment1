import Foundation
import Observation

@Observable
class AuthViewModel {
    var token: String?
    var name: String
    var email: String
    var sessionMessage = ""

    var isLoggedIn: Bool {
        token != nil
    }

    init() {
        UserDefaults.standard.removeObject(forKey: "token")

        token = AuthService.savedToken()
        name = UserDefaults.standard.string(forKey: "name") ?? ""
        email = UserDefaults.standard.string(forKey: "email") ?? ""

        APIService.onUnauthorized = { [weak self] in
            self?.expireSession()
        }
    }

    func restoreSession() async {
        guard let token else {
            return
        }

        if AuthService.isExpired(token) || !AuthService.isFirebaseSignedIn(as: email) {
            expireSession()
            return
        }

        if let me = try? await AuthService.me(), let apiName = me.name {
            name = apiName
            UserDefaults.standard.set(name, forKey: "name")
        }
    }

    func login(email: String, password: String) async throws {
        let result = try await AuthService.login(email: email, password: password)
        AuthService.saveToken(result.token)

        do {
            try await AuthService.signInToFirebase(email: email, password: password)
        } catch {
            AuthService.deleteToken()
            throw error
        }

        name = result.name ?? ""
        self.email = AuthService.firebaseEmail ?? email.lowercased()
        sessionMessage = ""
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(self.email, forKey: "email")

        token = result.token
    }

    func register(name: String, email: String, password: String) async throws {
        try await AuthService.register(name: name, email: email, password: password)
        try await login(email: email, password: password)
    }

    func logout() {
        AuthService.deleteToken()
        AuthService.signOutOfFirebase()
        token = nil
        name = ""
        email = ""
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "email")
    }

    func expireSession() {
        guard token != nil else {
            return
        }
        logout()
        sessionMessage = "Your session has expired. Please log in again."
    }

    func validate(name: String? = nil, email: String, password: String) -> String? {
        let email = email.trimmingCharacters(in: .whitespaces)

        if name?.trimmingCharacters(in: .whitespaces).isEmpty == true || email.isEmpty || password.isEmpty {
            return "Please fill in all fields."
        }
        if !email.contains("@") || !email.contains(".") {
            return "Please enter a valid email address."
        }
        if password.count < 6 {
            return "Password must be at least 6 characters."
        }
        if name != nil {
            if !password.contains(where: { $0.isUppercase }) {
                return "Password needs at least one uppercase letter."
            }
            if !password.contains(where: { $0.isNumber }) {
                return "Password needs at least one number."
            }
            if !password.contains(where: { !$0.isLetter && !$0.isNumber }) {
                return "Password needs at least one symbol (e.g. ! or @)."
            }
        }
        return nil
    }
}
