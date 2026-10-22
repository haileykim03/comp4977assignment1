import SwiftUI

// Registration screen: name, email and password
struct RegisterView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showingAlert = false

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                Text("At least 6 characters, with an uppercase letter, a number and a symbol.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section {
                Button("Create Account") {
                    register()
                }
                .disabled(isLoading)

                if isLoading {
                    ProgressView()
                }
            }
        }
        .navigationTitle("Register")
        .alert("Error", isPresented: $showingAlert, actions: {
            Button("OK", role: .none, action: {})
        }, message: {
            Text(errorMessage)
        })
    }

    func register() {
        // Validate the form first
        if let message = auth.validate(name: name, email: email, password: password) {
            errorMessage = message
            showingAlert = true
            return
        }

        // Create the account, then log in automatically
        Task {
            isLoading = true
            do {
                try await auth.register(name: name, email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
                showingAlert = true
            }
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
    .environmentObject(AuthViewModel())
}
