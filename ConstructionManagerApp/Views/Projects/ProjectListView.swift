import SwiftUI

struct ProjectListView: View {
    @StateObject private var viewModel = ProjectListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.projectViewModels, id: \.project.id) { projectViewModel in
                    NavigationLink(destination: ProjectDetailView(project: projectViewModel, viewModel: viewModel, projectIndex: viewModel.projects.firstIndex(where: { $0.id == projectViewModel.project.id })!)) {
                        ProjectRowView(project: projectViewModel.project)
                    }
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
