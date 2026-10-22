import Foundation
import Observation

// ViewModel for the Municipalities screen
@Observable
class MunicipalitiesViewModel {
    var municipalities: [Municipality] = []
    var errorMessage = ""
    var showingAlert = false

    // GET /api/municipalities
    func load() async {
        do {
            let data = try await APIService.send("/municipalities")
            // Convert the JSON array into [Municipality]
            municipalities = try JSONDecoder().decode([Municipality].self, from: data)
        } catch {
            errorMessage = error.localizedDescription
            showingAlert = true
        }
    }
}
