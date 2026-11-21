import SwiftUI

struct ContentView: View {
    @Environment(AuthViewModel.self) private var auth
    @Environment(CityViewModel.self) private var city
    @Environment(HomeViewModel.self) private var home
    @Environment(CandidatesViewModel.self) private var candidates
    @Environment(SelectionsViewModel.self) private var selections

    var body: some View {
        @Bindable var selections = selections
        @Bindable var city = city

        ZStack {
            if !auth.isLoggedIn {
                LoginView()
            } else if city.selected != nil {
                MainView()
            } else if city.hasLoaded {
                CityPickerView()
            } else if !city.errorMessage.isEmpty {
                loadError
            } else {
                ProgressView("Loading your profile…")
            }
        }
        .task {
            await auth.restoreSession()
        }
        .task(id: auth.token) {
            if auth.isLoggedIn {
                await city.load(email: auth.email)
            } else {
                resetAll()
            }
        }
        .task(id: city.selected?.municipalityId) {
            guard auth.isLoggedIn, let municipality = city.selected else {
                return
            }
            selections.start(email: auth.email, municipality: municipality)
            await candidates.load(municipality: municipality)
            await home.load(municipality: municipality)
        }
        .sheet(item: $selections.editor) { _ in
            SelectionEditorView()
        }
        .alert("Delete Selection?",
               isPresented: Binding(
                   get: { selections.pendingDelete != nil },
                   set: { if !$0 { selections.pendingDelete = nil } }
               ),
               presenting: selections.pendingDelete) { _ in
            Button("Delete", role: .destructive) {
                selections.deletePending()
            }
            Button("Cancel", role: .cancel) { }
        } message: { selection in
            Text("Remove \(selection.candidateName) from My Candidate Selections?")
        }
        .alert("My Candidate Selections", isPresented: $selections.showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(selections.errorMessage)
        }
        .alert("Municipality", isPresented: $city.showingSaveError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(city.saveErrorMessage)
        }
    }

    private var loadError: some View {
        ContentUnavailableView {
            Label("Can't Load Your Profile", systemImage: "exclamationmark.icloud")
        } description: {
            Text(city.errorMessage)
        } actions: {
            Button("Try Again") {
                Task { await city.load(email: auth.email) }
            }
            .buttonStyle(.borderedProminent)
            Button("Logout", role: .destructive) {
                auth.logout()
            }
        }
    }

    private func resetAll() {
        city.reset()
        home.reset()
        candidates.reset()
        selections.reset()
    }
}

#Preview {
    ContentView()
        .previewEnvironment()
}
