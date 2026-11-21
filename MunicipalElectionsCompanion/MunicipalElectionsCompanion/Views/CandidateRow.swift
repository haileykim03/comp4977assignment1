import SwiftUI

struct CandidateRow: View {
    let candidate: Candidate
    var isSelected = false

    var body: some View {
        HStack(spacing: 12) {
            CandidatePhoto(url: candidate.photoUrl, size: 50)

            VStack(alignment: .leading, spacing: 2) {
                Text(candidate.name)
                    .font(.headline)
                Text(candidate.position?.name ?? "")
                    .font(.subheadline)
                Text(candidate.municipality?.name ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
                    .accessibilityLabel("Selected")
            }
        }
    }
}

struct CandidateCard: View {
    let candidate: Candidate
    var isSelected = false

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            CandidatePhoto(url: candidate.photoUrl, size: 64)

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(candidate.name)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer(minLength: 4)
                    if isSelected {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                            .accessibilityLabel("Selected")
                    }
                }
                Text(candidate.position?.name ?? "")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.tint)
                Text(candidate.biography ?? "No biography.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                if let email = candidate.email {
                    Label(email, systemImage: "envelope")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 130, alignment: .topLeading)
        .background(Color.gray.opacity(0.12), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
        }
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("Row") {
    List {
        CandidateRow(candidate: PreviewData.candidate, isSelected: true)
        CandidateRow(candidate: PreviewData.candidates[1])
    }
}

#Preview("Card") {
    CandidateCard(candidate: PreviewData.candidate, isSelected: true)
        .padding()
}
