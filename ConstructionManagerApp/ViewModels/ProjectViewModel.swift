import Foundation

class ProjectViewModel: ObservableObject {
    @Published var project: Project

    init(project: Project) {
        self.project = project
    }

    func addTask(_ task: Task) {
        if project.tasks == nil {
            project.tasks = []
        }
        project.tasks?.append(task)
    }
    
    func toggleTaskCompletion(for taskID: UUID) {
        if let taskIndex = project.tasks?.firstIndex(where: { $0.id == taskID }) {
            project.tasks?[taskIndex].isCompleted.toggle()
        }
    }
    
    func updateStatus(for taskID: UUID, status: TaskStatus) {
        if let taskIndex = project.tasks?.firstIndex(where: { $0.id == taskID }) {
            project.tasks?[taskIndex].status = status
        }
    }
}
