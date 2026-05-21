import SwiftUI

struct AddTeamView: View {
    @Environment(\.dismiss) private var dismiss
    var onSave: (Team) -> Void

    @State private var name = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Team Name", text: $name)
                    .font(DS.body)
            }
            .navigationTitle("Add Team")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let team = Team(id: UUID(), name: name.isEmpty ? "Untitled Team" : name, createdAt: Date(), createdBy: nil, updatedAt: nil, members: [], projects: [])
                        onSave(team)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
    }
}
