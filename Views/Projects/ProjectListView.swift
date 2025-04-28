import SwiftUI

struct ProjectListView: View {
    @StateObject private var viewModel = ProjectListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.projectViewModels, id: \.project.id) { projectViewModel in
                    ProjectRow(projectViewModel: projectViewModel)
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddProjectView(viewModel: viewModel)) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Project")
                        }
                    }
                }
            }
        }
    }
}

// MARK: - ProjectRow Component
struct ProjectRow: View {
    let projectViewModel: ProjectViewModel
    @ObservedObject var viewModel = ProjectListViewModel()

    var body: some View {
        let projectIndex = viewModel.projects.firstIndex(where: { $0.id == projectViewModel.project.id }) ?? 0
        let destinationView = ProjectDetailView(project: projectViewModel, viewModel: viewModel, projectIndex: projectIndex)

        NavigationLink(destination: destinationView) {
            ProjectRowView(project: projectViewModel.project)
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}