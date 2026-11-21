import SwiftUI

struct RegisterView: View {
    @Environment(AuthViewModel.self) private var auth
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
                    .textContentType(.name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.username)
                SecureField("Password", text: $password)
                    .textContentType(.newPassword)
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
                    ProgressView("Creating account…")
                }
            }
        }
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Register")
        .alert("Error", isPresented: $showingAlert, actions: {
            Button("OK", role: .cancel, action: {})
        }, message: {
            Text(errorMessage)
        })
    }

    func register() {
        if let message = auth.validate(name: name, email: email, password: password) {
            errorMessage = message
            showingAlert = true
            return
        }

        Task {
            isLoading = true
            do {
                try await auth.register(name: name.trimmingCharacters(in: .whitespaces),
                                        email: email.trimmingCharacters(in: .whitespaces),
                                        password: password)
            } catch {
                errorMessage = ErrorMessage.from(error)
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
    .previewEnvironment()
}
