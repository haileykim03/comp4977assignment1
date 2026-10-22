import SwiftUI

// Login screen: email + password, validation, and a link to create an account
struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    // SecureField hides the password
                    SecureField("Password", text: $password)
                }

                Section {
                    Button("Login") {
                        login()
                    }
                    .disabled(isLoading)

                    if isLoading {
                        ProgressView()
                    }
                }

                Section {
                    // Go to the registration screen
                    NavigationLink("Create Account", destination: RegisterView())
                }
            }
            .navigationTitle("Login")
            // Shows validation and API error messages
            .alert("Error", isPresented: $showingAlert, actions: {
                Button("OK", role: .none, action: {})
            }, message: {
                Text(errorMessage)
            })
        }
    }

    func login() {
        // Validate the form first
        if let message = auth.validate(email: email, password: password) {
            errorMessage = message
            showingAlert = true
            return
        }

        // Call the API. When the token is set, ContentView switches to the tabs.
        Task {
            isLoading = true
            do {
                try await auth.login(email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
                showingAlert = true
            }
            isLoading = false
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
