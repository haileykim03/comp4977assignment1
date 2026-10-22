import SwiftUI

// Candidate Directory: search, filter, and tap a candidate to see the details
struct CandidatesView: View {
    @State private var viewModel = CandidatesViewModel()

    var body: some View {
        NavigationStack {
            List {
                // Filter by municipality and by position
                Section("Filter") {
                    Picker("Municipality", selection: $viewModel.selectedMunicipality) {
                        ForEach(viewModel.municipalityNames, id: \.self) { name in
                            Text(name)
                        }
                    }
                    Picker("Position", selection: $viewModel.selectedPosition) {
                        ForEach(viewModel.positionNames, id: \.self) { name in
                            Text(name)
                        }
                    }
                }

                Section("Candidates") {
                    ForEach(viewModel.filteredCandidates) { candidate in
                        // Tap a row to open the detail screen
                        NavigationLink(destination: CandidateDetailView(candidate: candidate)) {
                            CandidateRow(candidate: candidate)
                        }
                    }
                }
            }
            .navigationTitle("Candidates")
            // Search bar that filters by name
            .searchable(text: $viewModel.searchText, prompt: "Search by name")
            // Load the candidates from the API when the screen appears
            .task {
                await viewModel.load()
            }
            .alert("Error", isPresented: $viewModel.showingAlert, actions: {
                Button("OK", role: .none, action: {})
            }, message: {
                Text(viewModel.errorMessage)
            })
        }
    }
}

#Preview {
    CandidatesView()
        .environmentObject(AuthViewModel())
}
