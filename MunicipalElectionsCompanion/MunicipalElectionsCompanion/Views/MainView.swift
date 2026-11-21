import SwiftUI

enum AppSection: String, CaseIterable, Identifiable {
    case home, candidates, selections, profile

    var id: Self { self }

    var title: String {
        switch self {
        case .home: return "Home"
        case .candidates: return "Candidates"
        case .selections: return "My Selections"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .candidates: return "person.3"
        case .selections: return "checkmark.seal"
        case .profile: return "person.crop.circle"
        }
    }
}

struct MainView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(SelectionsViewModel.self) private var selections
    @Environment(CityViewModel.self) private var city
    @State private var section: AppSection = .home

    var body: some View {
        if horizontalSizeClass == .regular {
            NavigationSplitView {
                List(selection: sidebarSelection) {
                    Section {
                        ForEach(AppSection.allCases) { item in
                            Label(item.title, systemImage: item.icon)
                                .badge(item == .selections ? selections.selections.count : 0)
                        }
                    } header: {
                        Text("City: \(city.selected?.name ?? "-")")
                    }
                }
                .navigationTitle("Elections")
            } detail: {
                screen(for: section)
            }
        } else {
            TabView(selection: $section) {
                ForEach(AppSection.allCases) { item in
                    screen(for: item)
                        .tabItem {
                            Label(item.title, systemImage: item.icon)
                        }
                        .tag(item)
                        .badge(item == .selections ? selections.selections.count : 0)
                }
            }
        }
    }

    private var sidebarSelection: Binding<AppSection?> {
        Binding(
            get: { section },
            set: { newValue in
                if let newValue {
                    section = newValue
                }
            }
        )
    }

    @ViewBuilder
    private func screen(for item: AppSection) -> some View {
        switch item {
        case .home: HomeView()
        case .candidates: CandidatesView()
        case .selections: SelectionsView()
        case .profile: ProfileView()
        }
    }
}

#Preview("iPhone") {
    MainView()
        .previewEnvironment()
}

#Preview("iPad", traits: .landscapeLeft) {
    MainView()
        .environment(\.horizontalSizeClass, .regular)
        .previewEnvironment()
}
