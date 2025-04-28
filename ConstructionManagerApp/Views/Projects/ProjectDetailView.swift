import SwiftUI

struct ProjectDetailView: View {
    @ObservedObject var projectViewModel: ProjectViewModel
    @ObservedObject var viewModel: ProjectListViewModel
    var projectIndex: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(projectViewModel.project.name)
                    .font(.largeTitle)
                    .bold()

                HStack {
                    ProgressView(value: projectViewModel.project.progress)
                        .progressViewStyle(LinearProgressViewStyle())
                    Text("\(Int(projectViewModel.project.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)

                Text("Tasks")
                    .font(.headline)

                NavigationLink(destination: TaskListView(tasks: projectViewModel.project.tasks)) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("View All Tasks")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }

                ForEach(projectViewModel.project.tasks) { task in
                    TaskRowView(task: task, toggleCompletion: {
                        projectViewModel.toggleTaskCompletion(for: task.id)
                    })
                }

                Text("Expenses")
                    .font(.headline)
                ForEach(projectViewModel.project.expenses) { expense in
                    HStack {
                        Text(expense.description)
                        Spacer()
                        Text("$\(expense.amount, specifier: "%.2f")")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Project Details")
    }
}
