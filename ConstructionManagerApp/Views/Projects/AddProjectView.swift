import SwiftUI

struct AddProjectView: View {
    @ObservedObject var viewModel: ProjectListViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    @State private var budget: Double = 0.0

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $name)
                    TextField("Description", text: $description)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
                    TextField("Budget", value: $budget, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Project")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addProject(
                            name: name,
                            description: description,
                            startDate: startDate,
                            endDate: endDate,
                            budget: budget
                        )
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
    }
}
