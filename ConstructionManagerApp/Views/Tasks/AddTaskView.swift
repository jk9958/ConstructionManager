import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var tasks: [Task]

    @State private var title: String = ""
    @State private var durationInDays: Int = 1
    @State private var priority: TaskPriority = .medium

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    Stepper("Duration: \(durationInDays) days", value: $durationInDays, in: 1...365)
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newTask = Task(
                            id: UUID(),
                            title: title,
                            taskDescription: nil,
                            isCompleted: false,
                            durationInDays: durationInDays,
                            assignedTo: [],
                            priority: priority,
                            deadline: nil,
                            status: .notStarted,
                            startDate: Date(),
                            createdAt: Date(),
                            updatedAt: nil
                        )
                        tasks.append(newTask)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
