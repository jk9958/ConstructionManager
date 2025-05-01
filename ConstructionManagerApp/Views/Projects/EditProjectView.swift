import SwiftUI

struct EditProjectView: View {
    @Binding var project: Project
    @Environment(\.presentationMode) var presentationMode

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
        NavigationView {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { priority in
                            Text(priority)
                        }
                    }
                    Picker("Status", selection: $status) {
                        ForEach(statuses, id: \.self) { status in
                            Text(status)
                        }
                    }
                    TextField("Location", text: $location)
                        .autocapitalization(.words)
                    TextField("Budget", value: $budget, formatter: NumberFormatter.currency)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("Expected End Date", selection: $expectedEndDate, displayedComponents: .date)
                }
            }
            .navigationBarTitle("Edit Project", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveChanges()
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                loadProjectDetails()
            }
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
