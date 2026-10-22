import SwiftUI

// Municipalities screen: logo, name and election date
struct MunicipalitiesView: View {
    @State private var viewModel = MunicipalitiesViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.municipalities) { municipality in
                HStack {
                    // Load the logo from its URL
                    AsyncImage(url: URL(string: municipality.logoUrl ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .leading) {
                        Text(municipality.name)
                            .font(.headline)
                        // Show only the date part (yyyy-MM-dd)
                        Text("Election date: \(municipality.electionDate.prefix(10))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Municipalities")
            // Load the data from the API when the screen appears
            .task {
                await viewModel.load()
            }
            .alert("Error", isPresented: $viewModel.showingAlert, actions: {
                Button("OK", role: .none, action: {})
            }, message: {
                Text(viewModel.errorMessage)
            })
        }
    }
}

#Preview {
    MunicipalitiesView()
}
