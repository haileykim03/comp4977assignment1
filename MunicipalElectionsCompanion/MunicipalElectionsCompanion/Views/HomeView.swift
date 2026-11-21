import SwiftUI

struct HomeView: View {
    @Environment(HomeViewModel.self) private var viewModel
    @Environment(SelectionsViewModel.self) private var selections
    @Environment(CityViewModel.self) private var city
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var isWide: Bool {
        horizontalSizeClass == .regular || verticalSizeClass == .compact
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    if let election = viewModel.election {
                        Text("Positions on the ballot")
                            .font(.title2.bold())

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 240), spacing: 16)], spacing: 16) {
                            ForEach(election.positions) { position in
                                PositionCard(position: position,
                                             chosen: selections.count(forPositionId: position.positionId))
                            }
                        }
                    } else if viewModel.isLoading {
                        ProgressView("Loading election…")
                            .frame(maxWidth: .infinity)
                    } else if !viewModel.errorMessage.isEmpty {
                        ContentUnavailableView {
                            Label("Can't Load Election", systemImage: "wifi.exclamationmark")
                        } description: {
                            Text(viewModel.errorMessage)
                        } actions: {
                            Button("Try Again") {
                                Task { await reload() }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 1000)
                .frame(maxWidth: .infinity)
            }
            .refreshable {
                await reload()
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CityBadge()
                }
            }
        }
    }

    @ViewBuilder
    private var header: some View {
        let layout = isWide
            ? AnyLayout(HStackLayout(alignment: .center, spacing: 20))
            : AnyLayout(VStackLayout(alignment: .leading, spacing: 12))

        layout {
            MunicipalityLogo(url: city.selected?.logoUrl, size: isWide ? 100 : 80)

            VStack(alignment: .leading, spacing: 6) {
                Text("Municipal Elections Companion")
                    .font(.title.bold())
                Text("City: \(city.selected?.name ?? "-")")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.tint)
                if let election = viewModel.election {
                    Label("Election day: \(DateText.election(election.electionDate))", systemImage: "calendar")
                    if let description = election.description {
                        Text(description)
                            .foregroundStyle(.secondary)
                    }
                }
                Text("You have chosen \(selections.selections.count) candidate\(selections.selections.count == 1 ? "" : "s").")
                    .font(.subheadline)
            }
        }
    }

    private func reload() async {
        if let municipality = city.selected {
            await viewModel.load(municipality: municipality)
        }
    }
}

struct PositionCard: View {
    let position: PositionSummary
    let chosen: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(position.name)
                .font(.headline)
            Text("\(position.seatsAvailable) seat\(position.seatsAvailable == 1 ? "" : "s") · \(position.candidateCount) candidate\(position.candidateCount == 1 ? "" : "s")")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            ProgressView(value: Double(min(chosen, position.seatsAvailable)),
                         total: Double(max(position.seatsAvailable, 1)))
            Text("Your picks: \(chosen) of \(position.seatsAvailable)")
                .font(.footnote)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.12), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeView()
        .previewEnvironment()
}
