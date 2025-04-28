import Foundation

class ProjectListViewModel: ObservableObject {
    @Published var projects: [Project] = []

    var projectViewModels: [ProjectViewModel] {
        projects.map { ProjectViewModel(project: $0) }
    }
}