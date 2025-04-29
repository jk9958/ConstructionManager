import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var project: ProjectViewModel

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
                            title: title,
                            isCompleted: false,
                            durationInDays: durationInDays,
                            priority: priority,
                            startDate: Date()
                        )
                        project.addTask(newTask)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
