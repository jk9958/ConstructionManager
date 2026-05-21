import SwiftUI

struct ProjectListView: View {
    @StateObject private var viewModel = ProjectListViewModel()
    @State private var isAddingProject = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.projects) { project in
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        ProjectCardView(project: project)
                            .padding(.vertical, DS.s)
                            .listRowBackground(Color.appBackground)
                    }
                }
                .onDelete(perform: deleteProject)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
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
        viewModel.deleteProject(at: offsets)
    }
}

#Preview {
    ThemedPreview(theme: .brand) {
        ProjectListView()
    }
}
