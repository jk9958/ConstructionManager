import SwiftUI

struct ProjectListView: View {
    @StateObject private var viewModel = ProjectListViewModel()
    @State private var isAddingProject = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.projects) { project in
                    NavigationLink(destination: ProjectDetailView(project: project)) {
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
