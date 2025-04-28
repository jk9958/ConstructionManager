import SwiftUI
import Foundation

struct Project: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var startDate: Date
    var endDate: Date
    var budget: Double
    var tasks: [Task]
    var expenses: [Expense]
}

class ProjectListViewModel: ObservableObject {
    @Published var projects: [Project] = [
        Project(
            name: "Build a House",
            description: "Residential construction",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 30),
            budget: 50000,
            tasks: [],
            expenses: []
        ),
        Project(
            name: "Office Renovation",
            description: "Renovate office space",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 60),
            budget: 20000,
            tasks: [],
            expenses: []
        )
    ]
}

struct ProjectCardView: View {
    var project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name)
                .font(.headline)
                .padding(.bottom, 2)
            Text(project.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text("Budget: $\(project.budget, specifier: "%.2f")")
                    .font(.caption)
                Spacer()
                Text("Ends: \(project.endDate, style: .date)")
                    .font(.caption)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

struct ProjectCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCardView(
            project: Project(
                name: "Build a House",
                description: "Residential construction",
                startDate: Date(),
                endDate: Date().addingTimeInterval(86400 * 30),
                budget: 50000,
                tasks: [],
                expenses: []
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

struct ProjectListView: View {
    @ObservedObject var viewModel: ProjectListViewModel

    var body: some View {
        ScrollView {
            ForEach(viewModel.projects.indices, id: \.self) { index in
                NavigationLink(destination: ProjectDetailView(project: viewModel.projects[index])) {
                    ProjectCardView(project: viewModel.projects[index])
                }
            }
        }
    }
}

struct ProjectDetailView: View {
    var project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(project.name)
                .font(.largeTitle)
                .bold()
            Text(project.description)
                .font(.body)
            Text("Budget: $\(project.budget, specifier: "%.2f")")
                .font(.headline)
            Text("Ends: \(project.endDate, style: .date)")
                .font(.subheadline)
        }
        .padding()
        .navigationTitle("Project Details")
    }
}