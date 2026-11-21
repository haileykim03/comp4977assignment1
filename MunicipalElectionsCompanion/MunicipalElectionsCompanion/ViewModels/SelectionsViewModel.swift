import Foundation
import Observation

struct SelectionEditor: Identifiable {
    enum Mode {
        case add(Candidate)
        case edit(CandidateSelection)
    }

    let id = UUID()
    let mode: Mode

    var isAdding: Bool {
        if case .add = mode { return true }
        return false
    }

    var candidateName: String {
        switch mode {
        case .add(let candidate): return candidate.name
        case .edit(let selection): return selection.candidateName
        }
    }

    var photoUrl: String? {
        switch mode {
        case .add(let candidate): return candidate.photoUrl
        case .edit(let selection): return selection.photoUrl
        }
    }

    var details: String {
        switch mode {
        case .add(let candidate):
            return "\(candidate.position?.name ?? "") · \(candidate.municipality?.name ?? "")"
        case .edit(let selection):
            return "\(selection.positionName) · \(selection.municipalityName)"
        }
    }
}

@Observable
class SelectionsViewModel {
    static let maxNotesLength = 500

    var selections: [CandidateSelection] = []
    var isLoading = false
    var lastSync: Date?

    var editor: SelectionEditor?
    var draftNotes = ""
    var editorError = ""

    var pendingDelete: CandidateSelection?

    var errorMessage = ""
    var showingAlert = false

    @ObservationIgnored private var email = ""
    @ObservationIgnored private var municipality: Municipality?
    @ObservationIgnored private var stopListening: (() -> Void)?

    func start(email: String, municipality: Municipality) {
        stop()
        self.email = email
        self.municipality = municipality

        selections = []
        lastSync = nil
        isLoading = true

        stopListening = FirebaseService.listenToSelections(
            email: email,
            municipalityId: municipality.municipalityId,
            onChange: { [weak self] items, invalidCount, fromServer in
                guard let self else { return }
                self.selections = self.sortedForDisplay(items)
                self.isLoading = false
                if fromServer {
                    self.lastSync = Date()
                }
                if invalidCount > 0 {
                    self.showError("\(invalidCount) saved selection(s) had invalid data in Firebase and were skipped.")
                }
            },
            onError: { [weak self] error in
                self?.isLoading = false
                self?.showError(ErrorMessage.from(error))
            }
        )
    }

    func refresh() async {
        guard let municipality, !email.isEmpty else {
            return
        }

        do {
            let result = try await FirebaseService.fetchSelections(email: email, municipalityId: municipality.municipalityId)
            selections = sortedForDisplay(result.selections)
            lastSync = Date()
            if result.invalidCount > 0 {
                showError("\(result.invalidCount) saved selection(s) had invalid data in Firebase and were skipped.")
            }
        } catch {
            showError(ErrorMessage.from(error))
        }
    }

    func stop() {
        stopListening?()
        stopListening = nil
    }

    func reset() {
        stop()
        email = ""
        municipality = nil
        selections = []
        lastSync = nil
        isLoading = false
        editor = nil
        draftNotes = ""
        editorError = ""
        pendingDelete = nil
    }

    func selection(for candidateId: Int) -> CandidateSelection? {
        selections.first { $0.candidateId == candidateId }
    }

    func count(forPositionId positionId: Int) -> Int {
        selections.filter { $0.positionId == positionId }.count
    }

    func reasonCannotAdd(_ candidate: Candidate) -> String? {
        guard !email.isEmpty, let municipality else {
            return "Please log in and choose your municipality first."
        }
        guard let position = candidate.position,
              !candidate.name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return "This candidate is missing required information."
        }
        guard candidate.municipality?.municipalityId == municipality.municipalityId else {
            return "\(candidate.name) is not running in \(municipality.name)."
        }
        if selection(for: candidate.candidateId) != nil {
            return "\(candidate.name) is already in your selections."
        }
        if count(forPositionId: position.positionId) >= position.seatsAvailable {
            let seats = position.seatsAvailable
            return "You can choose at most \(seats) \(position.name)\(seats == 1 ? "" : "s") in \(municipality.name). Remove one first."
        }
        return nil
    }

    func notesError(_ notes: String) -> String? {
        if notes.count > Self.maxNotesLength {
            return "Notes cannot be longer than \(Self.maxNotesLength) characters."
        }
        return nil
    }

    func beginAdd(_ candidate: Candidate) {
        if let reason = reasonCannotAdd(candidate) {
            showError(reason)
            return
        }
        draftNotes = ""
        editorError = ""
        editor = SelectionEditor(mode: .add(candidate))
    }

    func beginEdit(_ selection: CandidateSelection) {
        draftNotes = selection.notes
        editorError = ""
        editor = SelectionEditor(mode: .edit(selection))
    }

    func saveEditor() {
        guard let editor, let municipality else {
            return
        }

        let notes = draftNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        if let message = notesError(notes) {
            editorError = message
            return
        }

        switch editor.mode {
        case .add(let candidate):
            if let reason = reasonCannotAdd(candidate) {
                editorError = reason
                return
            }
            guard let position = candidate.position else {
                return
            }

            let now = Date()
            let newSelection = CandidateSelection(
                id: UUID().uuidString,
                userEmail: email,
                candidateId: candidate.candidateId,
                candidateName: candidate.name,
                photoUrl: candidate.photoUrl,
                positionId: position.positionId,
                positionName: position.name,
                municipalityId: municipality.municipalityId,
                municipalityName: municipality.name,
                notes: notes,
                dateCreated: now,
                dateModified: now
            )

            selections = sortedForDisplay(selections + [newSelection])
            FirebaseService.addSelection(newSelection) { [weak self] error in
                self?.handleWriteResult(error)
            }

        case .edit(let selection):
            if let index = selections.firstIndex(where: { $0.id == selection.id }) {
                selections[index].notes = notes
                selections[index].dateModified = Date()
            }
            FirebaseService.updateNotes(selectionId: selection.id, notes: notes) { [weak self] error in
                self?.handleWriteResult(error)
            }
        }

        self.editor = nil
    }

    func askToDelete(_ selection: CandidateSelection) {
        pendingDelete = selection
    }

    func deletePending() {
        guard let selection = pendingDelete else {
            return
        }
        pendingDelete = nil

        selections.removeAll { $0.id == selection.id }
        FirebaseService.deleteSelection(selectionId: selection.id) { [weak self] error in
            self?.handleWriteResult(error)
        }
    }

    private func handleWriteResult(_ error: Error?) {
        if let error {
            showError(ErrorMessage.from(error))
        } else {
            lastSync = Date()
        }
    }

    private func sortedForDisplay(_ items: [CandidateSelection]) -> [CandidateSelection] {
        items.sorted { $0.dateCreated > $1.dateCreated }
    }

    private func showError(_ message: String) {
        errorMessage = message
        showingAlert = true
    }
}
