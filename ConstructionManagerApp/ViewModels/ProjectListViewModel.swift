import Foundation

class ProjectListViewModel: ObservableObject {
    @Published var projects: [Project] = [
        Project(
            name: "Project A",
            description: "Building a residential complex",
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date())!,
            budget: 100000,
            tasks: [
                Task(title: "Task 1", isCompleted: false, durationInDays: 5, assignedTo: "John", priority: .high, deadline: nil, status: .notStarted, startDate: Date()),
                Task(title: "Task 2", isCompleted: true, durationInDays: 3, assignedTo: "Alice", priority: .medium, deadline: nil, status: .notStarted, startDate: Date())
            ],
            expenses: [
                Expense(description: "Cement", amount: 20000, date: Date()),
                Expense(description: "Labor", amount: 30000, date: Date())
            ]
        )
    ]

    var projectViewModels: [ProjectViewModel] {
        projects.map { ProjectViewModel(project: $0) }
    }

    func toggleTaskCompletion(for projectIndex: Int, taskID: UUID) {
        guard projects.indices.contains(projectIndex) else { return }
        if let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == taskID }) {
            projects[projectIndex].tasks[taskIndex].isCompleted.toggle()
        }
    }

    func addProject(name: String, description: String, startDate: Date, endDate: Date, budget: Double) {
        let newProject = Project(
            name: name,
            description: description,
            startDate: startDate,
            endDate: endDate,
            budget: budget,
            tasks: [],
            expenses: []
        )
        projects.append(newProject)
    }

    func updateProject(at index: Int, name: String, description: String, startDate: Date, endDate: Date, budget: Double) {
        guard projects.indices.contains(index) else { return }
        projects[index].name = name
        projects[index].description = description
        projects[index].startDate = startDate
        projects[index].endDate = endDate
        projects[index].budget = budget
    }
    
    func updateTaskStatus(for projectIndex: Int, taskID: UUID, to newStatus: TaskStatus) {
        guard projects.indices.contains(projectIndex) else { return }
        if let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == taskID }) {
            projects[projectIndex].tasks[taskIndex].status = newStatus
        }
    }
}
