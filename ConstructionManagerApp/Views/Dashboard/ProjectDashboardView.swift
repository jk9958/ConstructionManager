import SwiftUI

struct ProjectDashboardView: View {
    @StateObject private var viewModel = ProjectListViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    searchBar
                    summaryView
                    createProjectButton
                    projectListNavigationButton // Navigate to ProjectListView
                    taskNavigationButton
                    expenseNavigationButton
                    filteredProjectListView
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }

    // Header View
    private var headerView: some View {
        VStack {
            Text("Welcome to Project Dashboard")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    // Search Bar
    private var searchBar: some View {
        TextField("Search Projects", text: $searchText)
            .padding(10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }

    // Summary View
    private var summaryView: some View {
        HStack {
            VStack {
                Text("\(viewModel.projects.count)")
                    .font(.largeTitle)
                    .bold()
                Text("Projects")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)

            VStack {
                Text("\(viewModel.projects.flatMap { $0.tasks }.filter { $0.isCompleted }.count)")
                    .font(.largeTitle)
                    .bold()
                Text("Completed Tasks")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    // "Create New Project" Button
    private var createProjectButton: some View {
        NavigationLink(destination: AddProjectView(viewModel: viewModel)) {
            HStack {
                Image(systemName: "plus.circle")
                    .font(.title2)
                Text("Create New Project")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }

    // Navigate to ProjectListView
    private var projectListNavigationButton: some View {
        NavigationLink(destination: ProjectListView()) {
            HStack {
                Image(systemName: "folder")
                    .font(.title2)
                Text("View All Projects")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.purple.opacity(0.2))
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }

    // Navigate to TaskListView
    private var taskNavigationButton: some View {
        NavigationLink(destination: TaskListView()) {
            HStack {
                Image(systemName: "list.bullet")
                    .font(.title2)
                Text("View Tasks")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.2))
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }

    // Navigate to ExpenseListView
    private var expenseNavigationButton: some View {
        NavigationLink(destination: ExpenseListView()) {
            HStack {
                Image(systemName: "creditcard")
                    .font(.title2)
                Text("View Expenses")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange.opacity(0.2))
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }

    // Filtered Project List View
    private var filteredProjectListView: some View {
        LazyVStack(spacing: 10) {
            ForEach(filteredProjects.indices, id: \.self) { index in
                NavigationLink(
                    destination: ProjectDetailView(
                        project: ProjectViewModel(project: filteredProjects[index]),
                        viewModel: viewModel,
                        projectIndex: index
                    )
                ) {
                    ProjectRowView(project: filteredProjects[index])
                }
            }
        }
    }

    // Filtered Projects
    private var filteredProjects: [Project] {
        if searchText.isEmpty {
            return viewModel.projects
        } else {
            return viewModel.projects.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct ProjectDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDashboardView()
    }
}
