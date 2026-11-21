import Foundation

nonisolated struct Municipality: Codable, Identifiable, Hashable {
    let municipalityId: Int
    let name: String
    let province: String?
    let electionDate: String
    let description: String?
    let logoUrl: String?

    var id: Int { municipalityId }
}

nonisolated struct Position: Codable, Identifiable, Hashable {
    let positionId: Int
    let name: String
    let seatsAvailable: Int

    var id: Int { positionId }
}

nonisolated struct Candidate: Codable, Identifiable, Hashable {
    let candidateId: Int
    let name: String
    let biography: String?
    let photoUrl: String?
    let website: String?
    let email: String?
    let position: Position?
    let municipality: Municipality?

    var id: Int { candidateId }
}

nonisolated struct ElectionSummary: Codable {
    let municipalityId: Int
    let name: String
    let province: String?
    let electionDate: String
    let description: String?
    let logoUrl: String?
    let positions: [PositionSummary]
}

nonisolated struct PositionSummary: Codable, Identifiable {
    let positionId: Int
    let name: String
    let seatsAvailable: Int
    let candidateCount: Int

    var id: Int { positionId }
}

nonisolated struct LoginRequest: Codable {
    let email: String
    let password: String
}

nonisolated struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

nonisolated struct LoginResponse: Codable {
    let token: String
    let name: String?
    let email: String?
}

nonisolated struct MeResponse: Codable {
    let name: String?
    let email: String?
}

nonisolated struct MessageResponse: Codable {
    let message: String
}
