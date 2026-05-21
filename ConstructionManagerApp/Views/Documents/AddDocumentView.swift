import SwiftUI

struct AddDocumentView: View {
    @Environment(\.dismiss) private var dismiss
    var project: Project?
    var onSave: (Document) -> Void

    @State private var name = ""
    @State private var description = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .font(DS.body)
                TextField("Description", text: $description)
                    .font(DS.body)
            }
            .navigationTitle("Add Document")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let doc = Document(id: UUID(), name: name.isEmpty ? "Untitled" : name, documentDescription: description.isEmpty ? nil : description, documentType: nil, data: nil, updatedAt: Date(), activities: nil, permissions: nil)
                        onSave(doc)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
    }
}
