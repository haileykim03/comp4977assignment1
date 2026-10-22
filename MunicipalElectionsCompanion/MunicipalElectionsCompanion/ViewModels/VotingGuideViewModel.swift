import Foundation
import Observation

// ViewModel for the voting guide.
// Every request sends the JWT token.
@Observable
class VotingGuideViewModel {
    var savedCandidates: [SavedCandidate] = []
    var message = ""
    var showingAlert = false

    // GET /api/savedcandidates
    func load(token: String) async {
        do {
            let data = try await APIService.send("/savedcandidates", token: token)
            savedCandidates = try JSONDecoder().decode([SavedCandidate].self, from: data)
        } catch {
            message = error.localizedDescription
            showingAlert = true
        }
    }

    // POST /api/savedcandidates
    func add(candidateId: Int, token: String) async {
        do {
            let body = try JSONEncoder().encode(SaveCandidateRequest(candidateId: candidateId))
            _ = try await APIService.send("/savedcandidates", method: "POST", body: body, token: token)
            message = "Added to your voting guide."
        } catch {
            message = error.localizedDescription
        }
        showingAlert = true
    }

    // DELETE /api/savedcandidates/{id}
    func remove(at offsets: IndexSet, token: String) async {
        // Get the ids first, then delete each one on the server
        let ids = offsets.map { savedCandidates[$0].savedCandidateId }

        for id in ids {
            do {
                _ = try await APIService.send("/savedcandidates/\(id)", method: "DELETE", token: token)
            } catch {
                message = error.localizedDescription
                showingAlert = true
            }
        }

        await load(token: token)   // refresh the list from the API
    }
}
