import SwiftUI

struct CandidatesView: View {
    @Environment(CandidatesViewModel.self) private var viewModel
    @Environment(SelectionsViewModel.self) private var selections
    @Environment(CityViewModel.self) private var city
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var useList: Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .regular
    }

    private var gridColumns: [GridItem] {
        if horizontalSizeClass == .regular {
            return [GridItem(.adaptive(minimum: 200), spacing: 16)]
        }
        return [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack(path: $viewModel.path) {
            content
                .navigationTitle("Candidates")
                .navigationDestination(for: Candidate.self) { candidate in
                    CandidateDetailView(candidate: candidate)
                }
                .searchable(text: $viewModel.searchText, prompt: "Search by name")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        CityBadge()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker("Position", selection: $viewModel.selectedPosition) {
                                ForEach(viewModel.positionNames, id: \.self) { name in
                                    Text(name)
                                }
                            }
                        } label: {
                            Label("Filter", systemImage: viewModel.selectedPosition == "All"
                                  ? "line.3.horizontal.decrease.circle"
                                  : "line.3.horizontal.decrease.circle.fill")
                        }
                    }
                }
                .refreshable {
                    if let municipality = city.selected {
                        await viewModel.load(municipality: municipality)
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.candidates.isEmpty {
            ProgressView("Loading candidates…")
        } else if !viewModel.errorMessage.isEmpty && viewModel.candidates.isEmpty {
            ContentUnavailableView {
                Label("Can't Load Candidates", systemImage: "wifi.exclamationmark")
            } description: {
                Text(viewModel.errorMessage)
            } actions: {
                Button("Try Again") {
                    Task {
                        if let municipality = city.selected {
                            await viewModel.load(municipality: municipality)
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        } else if viewModel.candidates.isEmpty {
            ContentUnavailableView("No Candidates Yet", systemImage: "person.3",
                                   description: Text("No candidates are running in \(city.selected?.name ?? "this municipality") yet."))
        } else if viewModel.filteredCandidates.isEmpty {
            ContentUnavailableView.search(text: viewModel.searchText)
        } else if useList {
            candidateList
        } else {
            candidateGrid
        }
    }

    private var candidateList: some View {
        List {
            if viewModel.selectedPosition != "All" {
                Text("Showing: \(viewModel.selectedPosition)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            ForEach(viewModel.filteredCandidates) { candidate in
                NavigationLink(value: candidate) {
                    CandidateRow(candidate: candidate,
                                 isSelected: selections.selection(for: candidate.candidateId) != nil)
                }
            }
        }
    }

    private var candidateGrid: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(viewModel.filteredCandidates) { candidate in
                    NavigationLink(value: candidate) {
                        CandidateCard(candidate: candidate,
                                      isSelected: selections.selection(for: candidate.candidateId) != nil)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

#Preview {
    CandidatesView()
        .previewEnvironment()
}
