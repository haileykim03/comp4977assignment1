import SwiftUI

// Profile screen: the logged-in user and a Logout button
struct ProfileView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Logged-in user") {
                    Label(auth.name, systemImage: "person")
                    Label(auth.email, systemImage: "envelope")
                }

                Button("Logout", role: .destructive) {
                    auth.logout()
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
