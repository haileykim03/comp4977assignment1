import SwiftUI

struct SelectionEditorView: View {
    @Environment(SelectionsViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        let notesCount = viewModel.draftNotes.count
        let tooLong = notesCount > SelectionsViewModel.maxNotesLength

        NavigationStack {
            Form {
                if let editor = viewModel.editor {
                    Section {
                        HStack(spacing: 14) {
                            CandidatePhoto(url: editor.photoUrl, size: 60)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(editor.candidateName)
                                    .font(.headline)
                                Text(editor.details)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section {
                    TextEditor(text: $viewModel.draftNotes)
                        .frame(minHeight: 150)
                } header: {
                    Text("My notes (optional)")
                } footer: {
                    HStack(alignment: .top) {
                        Text(viewModel.editorError)
                            .foregroundStyle(.red)
                        Spacer()
                        Text("\(notesCount)/\(SelectionsViewModel.maxNotesLength)")
                            .monospacedDigit()
                            .foregroundStyle(tooLong ? Color.red : Color.secondary)
                    }
                }
            }
            .navigationTitle(viewModel.editor?.isAdding == true ? "Add Selection" : "Edit Selection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.editor = nil
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveEditor()
                    }
                    .disabled(tooLong)
                }
            }
        }
    }
}

#Preview {
    let selections = PreviewData.selectionsViewModel()
    selections.beginEdit(PreviewData.selection)

    return SelectionEditorView()
        .environment(selections)
}
