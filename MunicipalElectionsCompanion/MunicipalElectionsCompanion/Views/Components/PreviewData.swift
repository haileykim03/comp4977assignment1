import SwiftUI

enum PreviewData {
    static let municipality = Municipality(
        municipalityId: 1,
        name: "Pitt Meadows",
        province: "BC",
        electionDate: "2026-10-17T00:00:00",
        description: "A small city known for its farmland and rivers.",
        logoUrl: "https://ui-avatars.com/api/?size=256&name=Pitt%20Meadows"
    )

    static let mayor = Position(positionId: 1, name: "Mayor", seatsAvailable: 1)
    static let councillor = Position(positionId: 2, name: "Councillor", seatsAvailable: 5)

    static let candidate = Candidate(
        candidateId: 1,
        name: "Daniel Okafor",
        biography: "Small business owner focused on local jobs.",
        photoUrl: "https://ui-avatars.com/api/?size=256&name=Daniel%20Okafor",
        website: "https://example.com",
        email: "daniel@example.com",
        position: mayor,
        municipality: municipality
    )

    static let candidates: [Candidate] = [
        candidate,
        Candidate(candidateId: 2, name: "Grace Whitfield", biography: "Retired nurse who wants better services for seniors.",
                  photoUrl: "https://ui-avatars.com/api/?size=256&name=Grace%20Whitfield", website: "https://example.com",
                  email: "grace@example.com", position: mayor, municipality: municipality),
        Candidate(candidateId: 3, name: "Priya Sandhu", biography: "Civil engineer who wants safer roads and crosswalks.",
                  photoUrl: "https://ui-avatars.com/api/?size=256&name=Priya%20Sandhu", website: "https://example.com",
                  email: "priya@example.com", position: councillor, municipality: municipality)
    ]

    static let selection = CandidateSelection(
        id: "preview-1",
        userEmail: "student@bcit.ca",
        candidateId: 1,
        candidateName: "Daniel Okafor",
        photoUrl: candidate.photoUrl,
        positionId: 1,
        positionName: "Mayor",
        municipalityId: 1,
        municipalityName: "Pitt Meadows",
        notes: "Strong plan for local jobs.",
        dateCreated: Date(),
        dateModified: Date()
    )

    static let election = ElectionSummary(
        municipalityId: 1,
        name: "Pitt Meadows",
        province: "BC",
        electionDate: "2026-10-17T00:00:00",
        description: "A small city known for its farmland and rivers.",
        logoUrl: municipality.logoUrl,
        positions: [
            PositionSummary(positionId: 1, name: "Mayor", seatsAvailable: 1, candidateCount: 2),
            PositionSummary(positionId: 2, name: "Councillor", seatsAvailable: 5, candidateCount: 6),
            PositionSummary(positionId: 3, name: "School Trustee", seatsAvailable: 2, candidateCount: 3)
        ]
    )

    static func authViewModel() -> AuthViewModel {
        let vm = AuthViewModel()
        vm.name = "Hailey Kim"
        vm.email = "student@bcit.ca"
        return vm
    }

    static func cityViewModel() -> CityViewModel {
        let vm = CityViewModel()
        vm.municipalities = [municipality]
        vm.selected = municipality
        vm.hasLoaded = true
        return vm
    }

    static func homeViewModel() -> HomeViewModel {
        let vm = HomeViewModel()
        vm.election = election
        return vm
    }

    static func candidatesViewModel() -> CandidatesViewModel {
        let vm = CandidatesViewModel()
        vm.candidates = candidates
        return vm
    }

    static func selectionsViewModel() -> SelectionsViewModel {
        let vm = SelectionsViewModel()
        vm.selections = [selection]
        vm.lastSync = Date()
        return vm
    }
}

extension View {
    func previewEnvironment() -> some View {
        self
            .environment(PreviewData.authViewModel())
            .environment(PreviewData.cityViewModel())
            .environment(PreviewData.homeViewModel())
            .environment(PreviewData.candidatesViewModel())
            .environment(PreviewData.selectionsViewModel())
    }
}
