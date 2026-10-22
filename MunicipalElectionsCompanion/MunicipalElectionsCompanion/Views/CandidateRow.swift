import SwiftUI

// One row in a candidate list (reused by Candidates and My Voting Guide)
struct CandidateRow: View {
    let candidate: Candidate

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: candidate.photoUrl ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(candidate.name)
                    .font(.headline)
                Text(candidate.position?.name ?? "")
                    .font(.subheadline)
                Text(candidate.municipality?.name ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
