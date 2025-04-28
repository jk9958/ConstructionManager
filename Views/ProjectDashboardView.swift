import SwiftUI

struct ProjectDashboardView: View {
    @StateObject private var viewModel = ProjectListViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.projects) { project in
                        NavigationLink(destination: ProjectDetailView(project: ProjectViewModel(project: project))) {
                            VStack(alignment: .leading) {
                                Text(project.name)
                                    .font(.headline)
                                Text("Budget: $\(project.budget, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Text("Deadline: \(project.endDate, style: .date)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Project Dashboard")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

struct ProjectDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDashboardView()
    }
}