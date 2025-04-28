import Foundation

class ProjectViewModel: ObservableObject {
    @Published var project: Project

    init(project: Project) {
        self.project = project
    }

    func addTask(_ task: Task) {
        project.tasks.append(task)
    }
}