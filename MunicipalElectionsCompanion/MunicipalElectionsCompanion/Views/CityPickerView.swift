import SwiftUI

struct CityPickerView: View {
    @Environment(CityViewModel.self) private var city
    @Environment(AuthViewModel.self) private var auth

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(city.municipalities) { municipality in
                        Button {
                            city.choose(municipality)
                        } label: {
                            HStack(spacing: 14) {
                                MunicipalityLogo(url: municipality.logoUrl, size: 50)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(municipality.name)
                                        .font(.headline)
                                    Text("Election day: \(DateText.election(municipality.electionDate))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.tertiary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("Where do you live?")
                } footer: {
                    Text("You will only see candidates and selections for this municipality. You can change it later in Profile.")
                }
            }
            .navigationTitle("Choose Municipality")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        auth.logout()
                    }
                }
            }
        }
    }
}

#Preview {
    let city = PreviewData.cityViewModel()
    city.selected = nil

    return CityPickerView()
        .environment(city)
        .previewEnvironment()
}
