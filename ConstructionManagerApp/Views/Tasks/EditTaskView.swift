import SwiftUI

struct EditTaskView: View {
    @Binding var task: Task
    @Environment(\.dismiss) private var dismiss
    var project: Project? {
        CoreDataManager.shared.fetchProjectModel(task.projectId ?? UUID())
    }

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var priority: TaskPriority = .medium
    @State private var status: TaskStatus = .notStarted
    @State private var startDate: Date = Date()
    @State private var deadline: Date = Date().oneYearLater
    @State private var isCompleted: Bool = false
    @State private var showErrorAlert = false
    @State private var alertMessage: String? = nil

    let priorities = TaskPriority.allCases
    let statuses = TaskStatus.allCases

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                        .accessibilityLabel("Task description")
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { priority in
                            Text(priority.rawValue.capitalized)
                        }
                    }
                    Picker("Status", selection: $status) {
                        ForEach(statuses, id: \.self) { status in
                            Text(status.rawValue.capitalized)
                        }
                    }
                    Toggle("Completed", isOn: $isCompleted)
                }

                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("Deadline", selection: $deadline, in: startDate..., displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation(.easeInOut) { saveChanges() }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .onAppear { loadTaskDetails() }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Save Failed"), message: Text(alertMessage ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
        }
    }

    private func loadTaskDetails() {
        title = task.title
        description = task.taskDescription ?? ""
        priority = task.priority
        status = task.status
        startDate = task.startDate
        deadline = task.deadline ?? Date().oneYearLater
        isCompleted = task.isCompleted
    }

    private func saveChanges() {
        task.title = title
        task.taskDescription = description
        task.priority = priority
        task.status = status
        task.startDate = startDate
        task.deadline = deadline
        task.isCompleted = isCompleted
        let success = CoreDataManager.shared.updateTask(task)
        if success {
            dismiss()
        } else {
            alertMessage = "Failed to update task. Please try again."
            showErrorAlert = true
        }
    }

    
}

extension Binding where Value == Date? {
    init(_ source: Binding<Date?>, replacingNilWith defaultValue: Date) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}

#Preview {
    @Previewable @State var task = Task(
        id: UUID(),
        title: "Excavation",
        taskDescription: "Excavate the site for foundation",
        isCompleted: false,
        durationInDays: 5,
        assignedTo: [],
        priority: .high,
        deadline: Date().addingTimeInterval(86400 * 7),
        status: .notStarted,
        startDate: Date(),
        createdAt: Date(),
        updatedAt: nil
    )
    ThemedPreview(theme: .brand) {
        EditTaskView(task: $task)
    }
}
