import Foundation
import FirebaseFirestore

enum FirebaseService {
    static let selectionsCollection = "CandidateSelections"
    static let profilesCollection = "UserProfiles"

    private static var db: Firestore {
        Firestore.firestore()
    }

    static func loadProfile(email: String) async throws -> UserProfile? {
        let snapshot = try await db.collection(profilesCollection).document(email).getDocument()

        guard snapshot.exists else {
            return nil
        }
        do {
            return try snapshot.data(as: UserProfile.self)
        } catch {
            throw InvalidFirebaseDataError()
        }
    }

    static func saveProfile(_ profile: UserProfile, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(profile)
            db.collection(profilesCollection).document(profile.userEmail).setData(data, completion: completion)
        } catch {
            completion(error)
        }
    }

    private static func selectionsQuery(email: String, municipalityId: Int) -> Query {
        db.collection(selectionsCollection)
            .whereField("userEmail", isEqualTo: email)
            .whereField("municipalityId", isEqualTo: municipalityId)
    }

    nonisolated private static func decode(_ snapshot: QuerySnapshot) -> (selections: [CandidateSelection], invalidCount: Int) {
        var selections: [CandidateSelection] = []
        var invalidCount = 0

        for document in snapshot.documents {
            if let selection = try? document.data(as: CandidateSelection.self) {
                selections.append(selection)
            } else {
                invalidCount += 1
            }
        }
        return (selections, invalidCount)
    }

    static func listenToSelections(email: String,
                                   municipalityId: Int,
                                   onChange: @escaping (_ selections: [CandidateSelection], _ invalidCount: Int, _ fromServer: Bool) -> Void,
                                   onError: @escaping (Error) -> Void) -> () -> Void {
        let registration = selectionsQuery(email: email, municipalityId: municipalityId)
            .addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                if let error {
                    onError(error)
                    return
                }
                guard let snapshot else {
                    return
                }
                let result = decode(snapshot)
                let fromServer = !snapshot.metadata.isFromCache && !snapshot.metadata.hasPendingWrites
                onChange(result.selections, result.invalidCount, fromServer)
            }

        return {
            registration.remove()
        }
    }

    static func fetchSelections(email: String, municipalityId: Int) async throws -> (selections: [CandidateSelection], invalidCount: Int) {
        let snapshot = try await selectionsQuery(email: email, municipalityId: municipalityId)
            .getDocuments(source: .server)
        return decode(snapshot)
    }

    static func addSelection(_ selection: CandidateSelection, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(selection)
            db.collection(selectionsCollection).document(selection.id).setData(data, completion: completion)
        } catch {
            completion(error)
        }
    }

    static func updateNotes(selectionId: String, notes: String, completion: @escaping (Error?) -> Void) {
        db.collection(selectionsCollection).document(selectionId).updateData([
            "notes": notes,
            "dateModified": Date()
        ], completion: completion)
    }

    static func deleteSelection(selectionId: String, completion: @escaping (Error?) -> Void) {
        db.collection(selectionsCollection).document(selectionId).delete(completion: completion)
    }
}
