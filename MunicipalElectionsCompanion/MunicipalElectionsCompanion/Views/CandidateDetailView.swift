import SwiftUI

// Candidate Details: photo, biography, website, email and the Add to Voting Guide button
struct CandidateDetailView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var viewModel = VotingGuideViewModel()
    let candidate: Candidate

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Load the photo from its URL
                AsyncImage(url: URL(string: candidate.photoUrl ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
                .clipShape(Circle())

                Text(candidate.name)
                    .font(.largeTitle)
                    .bold()
                Text("\(candidate.position?.name ?? "") · \(candidate.municipality?.name ?? "")")
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Biography").font(.headline)
                    Text(candidate.biography ?? "No biography.")

                    Text("Website").font(.headline)
                    if let website = candidate.website, let url = URL(string: website) {
                        Link(website, destination: url)
                    }

                    Text("Email").font(.headline)
                    Text(candidate.email ?? "-")
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // POST /api/savedcandidates, then show the result in an alert
                Button("Add to Voting Guide") {
                    Task {
                        await viewModel.add(candidateId: candidate.candidateId, token: auth.token ?? "")
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Voting Guide", isPresented: $viewModel.showingAlert, actions: {
            Button("OK", role: .none, action: {})
        }, message: {
            Text(viewModel.message)
        })
    }
}
