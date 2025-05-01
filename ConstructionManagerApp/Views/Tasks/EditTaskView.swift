import SwiftUI

struct EditTaskView: View {
    @Binding var task: Task?
    var project: Project
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var priority: TaskPriority = .medium
    @State private var status: TaskStatus = .notStarted
    @State private var startDate: Date = Date()
    @State private var deadline: Date = Date().oneYearLater
    @State private var isCompleted: Bool = false

    let priorities = TaskPriority.allCases
    let statuses = TaskStatus.allCases

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
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
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                }
            }
            .navigationBarTitle("Edit Task", displayMode: .inline)
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
                loadTaskDetails()
            }
        }
    }

    private func loadTaskDetails() {
        guard let task = task else { return }
        title = task.title
        description = task.taskDescription ?? ""
        priority = task.priority
        status = task.status
        startDate = task.startDate
        deadline = task.deadline ?? Date().oneYearLater
        isCompleted = task.isCompleted
    }

    private func saveChanges() {
        guard var task = task else { return }
        task.title = title
        task.taskDescription = description
        task.priority = priority
        task.status = status
        task.startDate = startDate
        task.deadline = deadline
        task.isCompleted = isCompleted
    }
}

extension Binding where Value == Date? {
    /// Provides a binding that replaces `nil` with a default value.
    init(_ source: Binding<Date?>, replacingNilWith defaultValue: Date) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}

struct EditTaskView_Previews: PreviewProvider {
    @State static var task: Task? = Task(
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
    static var project = Project(
        id: UUID(),
        name: "Construction Project",
        projectDescription: "A large-scale construction project",
        priority: "High",
        status: "In Progress",
        budget: 100000,
        location: "New York",
        startDate: Date(),
        expectedEndDate: Date().addingTimeInterval(86400 * 365),
        createdAt: Date(),
        updatedAt: nil,
        documents: [],
        expenses: [],
        tasks: [],
        team: nil
    )

    static var previews: some View {
        EditTaskView(task: $task, project: project)
    }
}
