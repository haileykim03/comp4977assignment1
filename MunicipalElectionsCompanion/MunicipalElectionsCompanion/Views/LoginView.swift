import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var auth
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    AppHeader()
                }
                .listRowBackground(Color.clear)

                if !auth.sessionMessage.isEmpty {
                    Section {
                        Label(auth.sessionMessage, systemImage: "clock.badge.exclamationmark")
                            .foregroundStyle(.orange)
                    }
                }

                Section {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(.username)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }

                Section {
                    Button("Login") {
                        login()
                    }
                    .disabled(isLoading)

                    if isLoading {
                        ProgressView("Signing in…")
                    }
                }

                Section {
                    NavigationLink("Create Account", destination: RegisterView())
                }
            }
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Login")
            .alert("Error", isPresented: $showingAlert, actions: {
                Button("OK", role: .cancel, action: {})
            }, message: {
                Text(errorMessage)
            })
        }
    }

    func login() {
        if let message = auth.validate(email: email, password: password) {
            errorMessage = message
            showingAlert = true
            return
        }

        Task {
            isLoading = true
            do {
                try await auth.login(email: email.trimmingCharacters(in: .whitespaces), password: password)
            } catch {
                errorMessage = ErrorMessage.from(error)
                showingAlert = true
            }
            isLoading = false
        }
    }
}

struct AppHeader: View {
    var body: some View {
        ViewThatFits {
            HStack(spacing: 16) {
                logo
                titles(alignment: .leading)
                    .fixedSize()
            }
            VStack(spacing: 10) {
                logo
                titles(alignment: .center)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var logo: some View {
        Image("AppLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .accessibilityHidden(true)
    }

    private func titles(alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 4) {
            Text("Municipal Elections Companion")
                .font(.title2.bold())
            Text("Know your candidates. Plan your vote.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    LoginView()
        .previewEnvironment()
}
