import SwiftUI

struct EditProjectView: View {
    @Binding var project: Project
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var priority: String = "Medium"
    @State private var status: String = "Not Started"
    @State private var budget: Double = 0.0
    @State private var location: String = ""
    @State private var startDate: Date = Date()
    @State private var expectedEndDate: Date = Date()

    let priorities = ["Low", "Medium", "High"]
    let statuses = ["Not Started", "In Progress", "Completed"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { Text($0) }
                    }
                    Picker("Status", selection: $status) {
                        ForEach(statuses, id: \.self) { Text($0) }
                    }
                    TextField("Location", text: $location)
                        .autocapitalization(.words)
                    TextField("Budget", value: $budget, formatter: NumberFormatter.currency)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("Expected End Date", selection: $expectedEndDate, in: startDate..., displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .onAppear { loadProjectDetails() }
        }
    }

    private func loadProjectDetails() {
        name = project.name ?? ""
        description = project.projectDescription ?? ""
        priority = project.priority ?? "Medium"
        status = project.status ?? "Not Started"
        budget = project.budget
        location = project.location ?? ""
        startDate = project.startDate ?? Date()
        expectedEndDate = project.expectedEndDate ?? Date()
    }

    private func saveChanges() {
        project.name = name
        project.projectDescription = description
        project.priority = priority
        project.status = status
        project.budget = budget
        project.location = location
        project.startDate = startDate
        project.expectedEndDate = expectedEndDate
    }
}

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
