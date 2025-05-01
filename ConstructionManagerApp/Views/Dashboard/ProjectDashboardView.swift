import SwiftUI

struct ProjectDashboardView: View {
    @StateObject private var viewModel = ProjectListViewModel()
    @State private var selectedProject: Project? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Dashboard Header
                    Text("Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    // Metrics Section
                    metricsSection
                        .padding(.horizontal)

                    // Projects Section
                    Text("Projects")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(viewModel.projects) { project in
                        Button(action: {
                            selectedProject = project
                        }) {
                            ProjectCardView(project: project)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .sheet(item: $selectedProject) { project in
                ProjectDetailView(project: project)
            }
        }
    }

    private var metricsSection: some View {
        HStack(spacing: 16) {
            MetricCardView(title: "Total Projects", value: "\(viewModel.projects.count)")
            MetricCardView(title: "In Progress", value: "\(viewModel.projects.filter { $0.status == "In Progress" }.count)")
            MetricCardView(title: "Completed", value: "\(viewModel.projects.filter { $0.status == "Completed" }.count)")
        }
    }
}

struct MetricCardView: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

struct ProjectDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDashboardView()
    }
}
