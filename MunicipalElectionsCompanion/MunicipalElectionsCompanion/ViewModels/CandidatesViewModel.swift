import Foundation
import Observation

@Observable
class CandidatesViewModel {
    var candidates: [Candidate] = []
    var searchText = ""
    var selectedPosition = "All"
    var path: [Candidate] = []
    var isLoading = false
    var errorMessage = ""

    var positions: [Position] {
        var seen = Set<Int>()
        return candidates
            .compactMap { $0.position }
            .sorted { $0.positionId < $1.positionId }
            .filter { seen.insert($0.positionId).inserted }
    }

    var positionNames: [String] {
        ["All"] + positions.map { $0.name }
    }

    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            let matchesName = searchText.isEmpty || candidate.name.localizedCaseInsensitiveContains(searchText)
            let matchesPosition = selectedPosition == "All" || candidate.position?.name == selectedPosition
            return matchesName && matchesPosition
        }
    }

    @ObservationIgnored private var loadedMunicipalityId: Int?

    func load(municipality: Municipality) async {
        if municipality.municipalityId != loadedMunicipalityId {
            candidates = []
            path = []
            searchText = ""
            selectedPosition = "All"
            loadedMunicipalityId = municipality.municipalityId
        }
        isLoading = true
        errorMessage = ""

        do {
            let result = try await APIService.get([Candidate].self, from: "/candidates", query: ["city": municipality.name])
            candidates = result.filter { $0.municipality?.municipalityId == municipality.municipalityId }
        } catch is CancellationError {
            return
        } catch {
            errorMessage = ErrorMessage.from(error)
        }

        isLoading = false
    }

    func candidate(withId id: Int) -> Candidate? {
        candidates.first { $0.candidateId == id }
    }

    func reset() {
        loadedMunicipalityId = nil
        candidates = []
        path = []
        searchText = ""
        selectedPosition = "All"
        isLoading = false
        errorMessage = ""
    }
}
