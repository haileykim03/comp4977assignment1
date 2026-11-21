import SwiftUI

struct SelectionsView: View {
    @Environment(SelectionsViewModel.self) private var viewModel
    @Environment(CandidatesViewModel.self) private var candidates
    @Environment(CityViewModel.self) private var city

    private struct SelectionGroup: Identifiable {
        let position: String
        let items: [CandidateSelection]
        var id: String { position }
    }

    private var groups: [SelectionGroup] {
        let positions = candidates.positions
        let names = positions.map { $0.name } +
            viewModel.selections.map { $0.positionName }.filter { name in !positions.contains { $0.name == name } }

        var seen = Set<String>()
        return names
            .filter { seen.insert($0).inserted }
            .map { name in SelectionGroup(position: name, items: viewModel.selections.filter { $0.positionName == name }) }
            .filter { !$0.items.isEmpty }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    LabeledContent("Municipality", value: city.selected?.name ?? "-")
                    LabeledContent("Saved selections", value: "\(viewModel.selections.count)")
                    LabeledContent("Last synced",
                                   value: viewModel.lastSync.map { DateText.dateTime($0) } ?? "Not yet")
                }

                ForEach(groups) { group in
                    Section {
                        ForEach(group.items) { selection in
                            SelectionRow(selection: selection)
                        }
                    } header: {
                        Text(sectionTitle(group.position, count: group.items.count))
                    }
                }
            }
            .overlay {
                if viewModel.isLoading && viewModel.selections.isEmpty {
                    ProgressView("Loading selections…")
                } else if viewModel.selections.isEmpty {
                    ContentUnavailableView("No Selections Yet",
                                           systemImage: "checkmark.seal",
                                           description: Text("Open a candidate and tap Add Selection."))
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
            .navigationTitle("My Candidate Selections")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CityBadge()
                }
            }
        }
    }

    private func sectionTitle(_ positionName: String, count: Int) -> String {
        if let position = candidates.positions.first(where: { $0.name == positionName }) {
            return "\(positionName) · \(count) of \(position.seatsAvailable)"
        }
        return positionName
    }
}

struct SelectionRow: View {
    @Environment(SelectionsViewModel.self) private var viewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let selection: CandidateSelection

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CandidatePhoto(url: selection.photoUrl, size: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text(selection.candidateName)
                    .font(.headline)
                Text("\(selection.positionName) · \(selection.municipalityName)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if !selection.notes.isEmpty {
                    Text(selection.notes)
                        .font(.callout)
                        .lineLimit(4)
                }
                Text("Saved \(DateText.dateTime(selection.dateCreated))")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if horizontalSizeClass == .regular {
                    HStack {
                        Button("Edit", systemImage: "pencil") {
                            viewModel.beginEdit(selection)
                        }
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            viewModel.askToDelete(selection)
                        }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .padding(.top, 4)
                }
            }

            Spacer(minLength: 8)

            if horizontalSizeClass != .regular {
                Menu {
                    Button("Edit Selection", systemImage: "pencil") {
                        viewModel.beginEdit(selection)
                    }
                    Button("Delete Selection", systemImage: "trash", role: .destructive) {
                        viewModel.askToDelete(selection)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .accessibilityLabel("Actions for \(selection.candidateName)")
                }
            }
        }
        .buttonStyle(.borderless)
        .padding(.vertical, 4)
        .swipeActions {
            Button("Delete", systemImage: "trash") {
                viewModel.askToDelete(selection)
            }
            .tint(.red)
            Button("Edit", systemImage: "pencil") {
                viewModel.beginEdit(selection)
            }
            .tint(.blue)
        }
    }
}

#Preview {
    SelectionsView()
        .previewEnvironment()
}
