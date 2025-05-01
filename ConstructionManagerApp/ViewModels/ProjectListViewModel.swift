import Foundation

class ProjectListViewModel: ObservableObject {
    @Published var projects: [Project] = []

    init() {
        // Load initial data or fetch from CoreDataManager if needed
        loadProjects()
    }

    func loadProjects() {
        // Fetch projects from Core Data using CoreDataManager
        projects = CoreDataManager.shared.fetchProjects()
    }

    var projectViewModels: [ProjectViewModel] {
        projects.map { ProjectViewModel(project: $0) }
    }

    func toggleTaskCompletion(for projectIndex: Int, taskID: UUID) {
        guard projects.indices.contains(projectIndex) else { return }
        if let taskIndex = projects[projectIndex].tasks?.firstIndex(where: { $0.id == taskID }) {
            projects[projectIndex].tasks?[taskIndex].isCompleted.toggle()
        }
    }

    func addProject(name: String, description: String, startDate: Date, endDate: Date, budget: Double) {
        let newProject = Project(
            id: UUID(),
            name: name,
            projectDescription: description,
            priority: "Medium",
            status: "Not Started",
            budget: budget,
            location: "Unknown",
            startDate: startDate,
            expectedEndDate: endDate,
            createdAt: Date(),
            updatedAt: nil,
            documents: [],
            expenses: [],
            tasks: [],
            team: nil
        )
        projects.append(newProject)
    }

    func updateProject(at index: Int, name: String, description: String, startDate: Date, endDate: Date, budget: Double) {
        guard projects.indices.contains(index) else { return }
        projects[index].name = name
        projects[index].projectDescription = description
        projects[index].startDate = startDate
        projects[index].expectedEndDate = endDate
        projects[index].budget = budget
    }

    func updateTaskStatus(for projectIndex: Int, taskID: UUID, to newStatus: TaskStatus) {
        guard projects.indices.contains(projectIndex) else { return }
        if let taskIndex = projects[projectIndex].tasks?.firstIndex(where: { $0.id == taskID }) {
            projects[projectIndex].tasks?[taskIndex].status = newStatus
        }
    }

    func addTask(to projectIndex: Int, task: Task) {
        guard projects.indices.contains(projectIndex) else { return }
        projects[projectIndex].tasks?.append(task)
    }

    func addExpense(to projectIndex: Int, expense: Expense) {
        guard projects.indices.contains(projectIndex) else { return }
        projects[projectIndex].expenses?.append(expense)
    }
}
