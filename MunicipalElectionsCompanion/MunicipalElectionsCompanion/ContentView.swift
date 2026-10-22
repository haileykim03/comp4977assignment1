import SwiftUI

// Root view: the login screen when logged out, the 4 tabs when logged in
struct ContentView: View {
    // Shared login state (created in MunicipalElectionsCompanionApp)
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        if auth.token == nil {
            LoginView()
        } else {
            // Tab bar with the four main screens
            TabView {
                MunicipalitiesView().tabItem {
                    Image(systemName: "building.2")
                    Text("Municipalities")
                }
                CandidatesView().tabItem {
                    Image(systemName: "person.3")
                    Text("Candidates")
                }
                VotingGuideView().tabItem {
                    Image(systemName: "checkmark.seal")
                    Text("My Guide")
                }
                ProfileView().tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
