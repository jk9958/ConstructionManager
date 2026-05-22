import SwiftUI

struct ProjectDashboardView: View {
    @StateObject private var viewModel = ProjectListViewModel()
    @State private var selectedProject: Project? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.l) {
                    // Dashboard Header
                    Text("Dashboard")
                        .font(DS.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal)

                    // Metrics Section
                    metricsSection
                        .padding(.horizontal)

                    // Projects Section
                    Text("Projects")
                        .font(DS.subtitle)
                        .foregroundColor(DS.theme.secondaryText)
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
            .background(Color.appBackground)
            .navigationTitle("Dashboard")
            .sheet(item: $selectedProject) { project in
                ProjectDetailView(project: project)
            }
        }
    }

    private var metricsSection: some View {
        HStack(spacing: 16) {
            MetricCardView(title: "Total Projects", value: "\(viewModel.projects.count)")
            MetricCardView(title: "In Progress", value: "\(viewModel.projects.filter { $0.status == .inProgress }.count)")
            MetricCardView(title: "Completed", value: "\(viewModel.projects.filter { $0.status == .completed }.count)")
        }
    }
}

struct MetricCardView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: DS.s) {
            Text(value)
                .font(DS.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text(title)
                .font(DS.caption)
                .foregroundColor(DS.theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(DS.m)
        .background(Color.appCard)
        .cornerRadius(DS.cornerRadius)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ThemedPreview(theme: .brand) {
        ProjectDashboardView()
    }
}
