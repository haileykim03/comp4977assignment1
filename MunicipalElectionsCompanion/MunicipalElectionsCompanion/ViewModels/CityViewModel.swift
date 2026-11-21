import Foundation
import Observation

@Observable
class CityViewModel {
    var municipalities: [Municipality] = []
    var selected: Municipality?
    var isLoading = false
    var hasLoaded = false
    var errorMessage = ""
    var saveErrorMessage = ""
    var showingSaveError = false

    @ObservationIgnored private var email = ""

    func load(email: String) async {
        self.email = email
        isLoading = true
        errorMessage = ""

        do {
            municipalities = try await APIService.get([Municipality].self, from: "/municipalities", requiresAuth: false)
            let profile = try await FirebaseService.loadProfile(email: email)
            selected = municipalities.first { $0.municipalityId == profile?.municipalityId }
            hasLoaded = true
        } catch is CancellationError {
            return
        } catch {
            errorMessage = ErrorMessage.from(error)
        }

        isLoading = false
    }

    func choose(_ municipality: Municipality) {
        guard municipality.municipalityId != selected?.municipalityId else {
            return
        }
        selected = municipality

        let profile = UserProfile(
            userEmail: email,
            municipalityId: municipality.municipalityId,
            municipalityName: municipality.name,
            dateModified: Date()
        )

        FirebaseService.saveProfile(profile) { [weak self] error in
            if let error {
                self?.saveErrorMessage = ErrorMessage.from(error)
                self?.showingSaveError = true
            }
        }
    }

    func reset() {
        municipalities = []
        selected = nil
        hasLoaded = false
        isLoading = false
        errorMessage = ""
        email = ""
    }
}
