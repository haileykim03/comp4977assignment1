import Foundation

// Property names match the JSON from our API

// Codable = can be converted from/to JSON
struct Municipality: Codable, Identifiable {
    let municipalityId: Int
    let name: String
    let province: String?
    let electionDate: String
    let description: String?
    let logoUrl: String?

    var id: Int { municipalityId }   // List / ForEach need an id
}

struct Position: Codable {
    let positionId: Int
    let name: String
    let seatsAvailable: Int
}

// position and municipality are filled by Include() in the API
struct Candidate: Codable, Identifiable {
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

// A candidate in the user's voting guide
struct SavedCandidate: Codable, Identifiable {
    let savedCandidateId: Int
    let candidateId: Int
    let dateSaved: String
    let candidate: Candidate?

    var id: Int { savedCandidateId }
}

// Bodies we send to / receive from the API

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
    let name: String?
    let email: String?
}

struct SaveCandidateRequest: Codable {
    let candidateId: Int
}

struct MessageResponse: Codable {
    let message: String
}
