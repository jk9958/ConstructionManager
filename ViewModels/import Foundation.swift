import Foundation

class ProjectViewModel: ObservableObject {
    @Published var projects: [Project] = []

    func addProject(_ project: Project) {
        projects.append(project)
    }

    func removeProject(at index: Int) {
        projects.remove(at: index)
    }
}