import Foundation
import Observation

// ViewModel for the Candidate Directory
@Observable
class CandidatesViewModel {
    var candidates: [Candidate] = []
    // Bound to the search bar and the two filter pickers
    var searchText = ""
    var selectedMunicipality = "All"
    var selectedPosition = "All"
    var errorMessage = ""
    var showingAlert = false

    // Choices for the filter pickers
    var municipalityNames: [String] {
        ["All"] + Set(candidates.compactMap { $0.municipality?.name }).sorted()
    }

    var positionNames: [String] {
        ["All"] + Set(candidates.compactMap { $0.position?.name }).sorted()
    }

    // Candidates that match the search text and both filters
    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            let matchesName = searchText.isEmpty || candidate.name.localizedCaseInsensitiveContains(searchText)
            let matchesMunicipality = selectedMunicipality == "All" || candidate.municipality?.name == selectedMunicipality
            let matchesPosition = selectedPosition == "All" || candidate.position?.name == selectedPosition
            return matchesName && matchesMunicipality && matchesPosition
        }
    }

    // GET /api/candidates
    func load() async {
        do {
            let data = try await APIService.send("/candidates")
            candidates = try JSONDecoder().decode([Candidate].self, from: data)
        } catch {
            errorMessage = error.localizedDescription
            showingAlert = true
        }
    }
}
