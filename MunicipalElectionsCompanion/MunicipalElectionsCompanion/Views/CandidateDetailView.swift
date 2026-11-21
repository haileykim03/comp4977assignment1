import SwiftUI

struct CandidateDetailView: View {
    @Environment(SelectionsViewModel.self) private var selections
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    let candidate: Candidate

    private var isWide: Bool {
        horizontalSizeClass == .regular || verticalSizeClass == .compact
    }

    var body: some View {
        ScrollView {
            Group {
                if isWide {
                    HStack(alignment: .top, spacing: 32) {
                        CandidatePhoto(url: candidate.photoUrl, size: 200)
                        VStack(alignment: .leading, spacing: 20) {
                            information
                            selectionSection
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        CandidatePhoto(url: candidate.photoUrl, size: 150)
                        information
                        selectionSection
                    }
                }
            }
            .padding()
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(candidate.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var information: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(candidate.name)
                .font(.largeTitle)
                .bold()
            Text("\(candidate.position?.name ?? "") · \(candidate.municipality?.name ?? "")")
                .font(.title3)
                .foregroundStyle(.secondary)

            Text("Biography").font(.headline)
            Text(candidate.biography ?? "No biography.")

            if let website = candidate.website, let url = URL(string: website) {
                Text("Website").font(.headline)
                Link(website, destination: url)
            }

            if let email = candidate.email {
                Text("Email").font(.headline)
                if let url = URL(string: "mailto:\(email)") {
                    Link(email, destination: url)
                } else {
                    Text(email)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var selectionSection: some View {
        GroupBox {
            if let saved = selections.selection(for: candidate.candidateId) {
                VStack(alignment: .leading, spacing: 10) {
                    Label("In My Candidate Selections", systemImage: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                        .font(.headline)
                    Text("Saved \(DateText.dateTime(saved.dateCreated))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(saved.notes.isEmpty ? "No notes." : saved.notes)

                    ViewThatFits {
                        HStack {
                            editButton(saved)
                            deleteButton(saved)
                        }
                        VStack(alignment: .leading) {
                            editButton(saved)
                            deleteButton(saved)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    if let position = candidate.position {
                        Text("\(position.name): \(selections.count(forPositionId: position.positionId)) of \(position.seatsAvailable) chosen")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    let reason = selections.reasonCannotAdd(candidate)
                    if let reason {
                        Label(reason, systemImage: "exclamationmark.triangle")
                            .font(.footnote)
                            .foregroundStyle(.orange)
                    }

                    Button {
                        selections.beginAdd(candidate)
                    } label: {
                        Label("Add Selection", systemImage: "plus.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(reason != nil)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        } label: {
            Text("My Selection")
        }
    }

    private func editButton(_ saved: CandidateSelection) -> some View {
        Button {
            selections.beginEdit(saved)
        } label: {
            Label("Edit Selection", systemImage: "pencil")
        }
        .buttonStyle(.bordered)
    }

    private func deleteButton(_ saved: CandidateSelection) -> some View {
        Button(role: .destructive) {
            selections.askToDelete(saved)
        } label: {
            Label("Delete Selection", systemImage: "trash")
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    NavigationStack {
        CandidateDetailView(candidate: PreviewData.candidate)
    }
    .previewEnvironment()
}
