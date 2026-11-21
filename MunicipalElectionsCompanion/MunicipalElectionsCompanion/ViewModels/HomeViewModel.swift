import Foundation
import Observation

@Observable
class HomeViewModel {
    var election: ElectionSummary?
    var isLoading = false
    var errorMessage = ""

    func load(municipality: Municipality) async {
        if election?.municipalityId != municipality.municipalityId {
            election = nil
        }
        isLoading = true
        errorMessage = ""

        do {
            let summary = try await APIService.get(ElectionSummary.self, from: "/elections", query: ["city": municipality.name])
            if summary.municipalityId == municipality.municipalityId {
                election = summary
            } else {
                errorMessage = "The server returned data for the wrong municipality."
            }
        } catch is CancellationError {
            return
        } catch {
            errorMessage = ErrorMessage.from(error)
        }

        isLoading = false
    }

    func reset() {
        election = nil
        isLoading = false
        errorMessage = ""
    }
}
