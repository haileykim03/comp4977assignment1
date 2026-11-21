import Foundation

nonisolated struct CandidateSelection: Codable, Identifiable, Equatable {
    var id: String
    var userEmail: String
    var candidateId: Int
    var candidateName: String
    var photoUrl: String?
    var positionId: Int
    var positionName: String
    var municipalityId: Int
    var municipalityName: String
    var notes: String
    var dateCreated: Date
    var dateModified: Date
}

nonisolated struct UserProfile: Codable {
    var userEmail: String
    var municipalityId: Int
    var municipalityName: String
    var dateModified: Date
}
