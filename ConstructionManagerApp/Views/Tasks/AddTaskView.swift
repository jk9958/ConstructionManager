import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    var project: Project

    @State private var title: String = ""
    @State private var description: String = "" // Added description state
    @State private var durationInDays: Int = 1
    @State private var priority: TaskPriority = .medium

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $description) // Added TextEditor for description
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.vertical, 4)
                        .foregroundColor(.primary)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(false)
                        .placeholder(when: description.isEmpty) {
                            Text("Enter task description...")
                                .foregroundColor(.gray)
                                .padding(.leading, 4)
                        }
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
                        guard !title.isEmpty else {
                            // Show an alert or validation message
                            return
                        }
                        saveTask()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    private func saveTask() {
        let newTask = Task(
            id: UUID(),
            title: title,
            taskDescription: description.isEmpty ? "No description provided" : description, // Save description
            isCompleted: false,
            durationInDays: durationInDays,
            assignedTo: [],
            priority: priority,
            deadline: Date().addingTimeInterval(Double(durationInDays) * 86400), // Convert durationInDays to Double
            status: .notStarted,
            startDate: Date(),
            createdAt: Date(),
            updatedAt: nil
        )
        CoreDataManager.shared.createTask(from: newTask, forProjectId: project.id)
    }
}

extension View {
    /// Adds a placeholder to a `TextEditor`.
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .topLeading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
