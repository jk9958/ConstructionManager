import SwiftUI

struct EditProjectView: View {
    @ObservedObject var viewModel: ProjectListViewModel
    var projectIndex: Int

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
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

                Button("Save Changes") {
                    viewModel.updateProject(
                        at: projectIndex,
                        name: name,
                        description: description,
                        startDate: startDate,
                        endDate: endDate,
                        budget: budget
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Edit Project")
            .onAppear {
                let project = viewModel.projects[projectIndex]
                name = project.name
                description = project.description
                startDate = project.startDate
                endDate = project.endDate
                budget = project.budget
            }
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(viewModel: ProjectListViewModel(), projectIndex: 0)
    }
}