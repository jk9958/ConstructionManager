import Foundation

class ProjectListViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var projectViewModels: [ProjectViewModel] = []
    @Published var errorMessage: String?

    init() {
        // Load initial data or fetch from CoreDataManager if needed
        loadProjects()
    }

    func loadProjects() {
        // Fetch projects from Core Data using CoreDataManager
        projects = CoreDataManager.shared.fetchProjects()
        projectViewModels = projects.map { ProjectViewModel(project: $0) }
    }

    func toggleTaskCompletion(for projectIndex: Int, taskID: UUID) {
        guard projects.indices.contains(projectIndex) else { return }
        if let taskIndex = projects[projectIndex].tasks?.firstIndex(where: { $0.id == taskID }) {
            projects[projectIndex].tasks?[taskIndex].isCompleted.toggle()
            if let task = projects[projectIndex].tasks?[taskIndex] {
                let success = CoreDataManager.shared.updateTask(task)
                if !success {
                    // revert on failure and publish error
                    projects[projectIndex].tasks?[taskIndex].isCompleted.toggle()
                    errorMessage = "Failed to update task completion."
                }
            }
        }
    }

    func addProject(name: String, description: String, startDate: Date, endDate: Date, budget: Double) {
        let newProject = Project(
            id: UUID(),
            name: name,
            projectDescription: description,
            priority: .medium,
            status: .notStarted,
            budget: budget,
            location: "Unknown",
            startDate: startDate,
            expectedEndDate: endDate,
            createdAt: Date(),
            updatedAt: Date(),
            documents: [],
            expenses: [],
            tasks: [],
            team: nil
        )
        projects.append(newProject)
        projectViewModels.append(ProjectViewModel(project: newProject))
        CoreDataManager.shared.createProject(from: newProject)
    }

    func updateProject(at index: Int, name: String, description: String, startDate: Date, endDate: Date, budget: Double) {
        guard projects.indices.contains(index) else { return }
        projects[index].name = name
        projects[index].projectDescription = description
        projects[index].startDate = startDate
        projects[index].expectedEndDate = endDate
        projects[index].budget = budget
        CoreDataManager.shared.updateProject(from: projects[index])
    }

    func updateTaskStatus(for projectIndex: Int, taskID: UUID, to newStatus: TaskStatus) {
        guard projects.indices.contains(projectIndex) else { return }
        if let taskIndex = projects[projectIndex].tasks?.firstIndex(where: { $0.id == taskID }) {
            let previous = projects[projectIndex].tasks?[taskIndex].status
            projects[projectIndex].tasks?[taskIndex].status = newStatus
            if let task = projects[projectIndex].tasks?[taskIndex] {
                let success = CoreDataManager.shared.updateTask(task)
                if !success {
                    projects[projectIndex].tasks?[taskIndex].status = previous ?? .notStarted
                    errorMessage = "Failed to update task status."
                }
            }
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

    func deleteProject(at offsets: IndexSet) {
        for index in offsets {
            CoreDataManager.shared.deleteProject(projects[index])
        }
        projects.remove(atOffsets: offsets)
        projectViewModels.remove(atOffsets: offsets)
    }
}
