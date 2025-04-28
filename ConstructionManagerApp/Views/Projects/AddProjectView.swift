import SwiftUI

struct AddProjectView: View {
    @ObservedObject var viewModel: ProjectListViewModel

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
    @State private var budget: Double = 0.0

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $name)
                    TextField("Description", text: $description)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    TextField("Budget", value: $budget, format: .number)
                        .keyboardType(.decimalPad)
                }

                Button("Add Project") {
                    viewModel.addProject(
                        name: name,
                        description: description,
                        startDate: startDate,
                        endDate: endDate,
                        budget: budget
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add Project")
        }
    }
}
