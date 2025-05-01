import SwiftUI

struct ProjectListView: View {
    @StateObject private var viewModel = ProjectListViewModel()
    @State private var isAddingProject = false
    @State private var selectedProject: Project? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.projects) { project in
                    Button(action: {
                        selectedProject = project
                    }) {
                        ProjectCardView(project: project)
                            .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteProject)
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingProject = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $selectedProject) { project in
                ProjectDetailView(project: project)
            }
            .sheet(isPresented: $isAddingProject) {
                AddProjectView(viewModel: viewModel)
            }
        }
    }

    private func deleteProject(at offsets: IndexSet) {
        for index in offsets {
            viewModel.projects.remove(at: index)
            // Optionally, delete from Core Data
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
