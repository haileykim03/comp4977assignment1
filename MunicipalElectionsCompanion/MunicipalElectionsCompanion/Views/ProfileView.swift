import SwiftUI

struct ProfileView: View {
    @Environment(AuthViewModel.self) private var auth
    @Environment(CityViewModel.self) private var city
    @Environment(SelectionsViewModel.self) private var selections

    private var municipalityId: Binding<Int?> {
        Binding(
            get: { city.selected?.municipalityId },
            set: { newId in
                if let municipality = city.municipalities.first(where: { $0.municipalityId == newId }) {
                    city.choose(municipality)
                }
            }
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Logged-in user") {
                    LabeledContent("Name", value: auth.name.isEmpty ? "-" : auth.name)
                    LabeledContent("Email", value: auth.email)
                }

                Section {
                    Picker("Municipality", selection: municipalityId) {
                        ForEach(city.municipalities) { municipality in
                            Text(municipality.name).tag(municipality.municipalityId as Int?)
                        }
                    }
                    if let selected = city.selected {
                        LabeledContent("Election day", value: DateText.election(selected.electionDate))
                    }
                } header: {
                    Text("My municipality")
                } footer: {
                    Text("Changing your municipality reloads all election data. Only selections for the new municipality are shown.")
                }

                Section("Candidate selections") {
                    LabeledContent("Total saved selections", value: "\(selections.selections.count)")
                    LabeledContent("Last synchronization",
                                   value: selections.lastSync.map { DateText.dateTime($0) } ?? "Not yet")
                    Button("Sync Now", systemImage: "arrow.triangle.2.circlepath") {
                        Task { await selections.refresh() }
                    }
                }

                Section {
                    Button("Logout", role: .destructive) {
                        auth.logout()
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CityBadge()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .previewEnvironment()
}
