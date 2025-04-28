import SwiftUI

struct EditTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    var taskIndex: Int

    @State private var title: String = ""
    @State private var assignedTo: String = ""
    @State private var priority: TaskPriority = .medium
    @State private var deadline: Date = Date()

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Task Details")) {
                    TextField("Task Title", text: $title)
                    TextField("Assigned To", text: $assignedTo)
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                }

                Button("Save Changes") {
                    viewModel.updateTask(
                        at: taskIndex,
                        title: title,
                        assignedTo: assignedTo.isEmpty ? nil : assignedTo,
                        priority: priority,
                        deadline: deadline
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Edit Task")
            .onAppear {
                let task = viewModel.tasks[taskIndex]
                title = task.title
                assignedTo = task.assignedTo ?? ""
                priority = task.priority
                deadline = task.deadline ?? Date()
            }
        }
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskView(viewModel: TaskViewModel(), taskIndex: 0)
    }
}
