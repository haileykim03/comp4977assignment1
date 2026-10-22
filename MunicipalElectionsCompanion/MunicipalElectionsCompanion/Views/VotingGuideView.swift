import SwiftUI

// My Voting Guide: the saved candidates, swipe or tap Edit to remove one
struct VotingGuideView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var viewModel = VotingGuideViewModel()

    var body: some View {
        NavigationStack {
            List {
                if viewModel.savedCandidates.isEmpty {
                    Text("Your voting guide is empty. Add candidates from the Candidates tab.")
                        .foregroundStyle(.secondary)
                }

                ForEach(viewModel.savedCandidates) { saved in
                    if let candidate = saved.candidate {
                        CandidateRow(candidate: candidate)
                    }
                }
                // Swipe to delete -> DELETE /api/savedcandidates/{id}
                .onDelete { offsets in
                    Task {
                        await viewModel.remove(at: offsets, token: auth.token ?? "")
                    }
                }
            }
            .navigationTitle("My Voting Guide")
            .toolbar {
                EditButton()
            }
            // Reload the guide each time the tab is opened
            .task {
                await viewModel.load(token: auth.token ?? "")
            }
            .alert("Voting Guide", isPresented: $viewModel.showingAlert, actions: {
                Button("OK", role: .none, action: {})
            }, message: {
                Text(viewModel.message)
            })
        }
    }
}

#Preview {
    VotingGuideView()
        .environmentObject(AuthViewModel())
}
