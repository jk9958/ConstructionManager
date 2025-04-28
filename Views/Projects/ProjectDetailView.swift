import SwiftUI

struct ProjectDetailView: View {
    @ObservedObject var project: ProjectViewModel
    @ObservedObject var viewModel: ProjectListViewModel
    var projectIndex: Int
    @State private var isPresentingAddTaskView = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(project.project.name)
                    .font(.largeTitle)
                    .bold()

                HStack {
                    ProgressView(value: project.project.progress)
                        .progressViewStyle(LinearProgressViewStyle())
                    Text("\(Int(project.project.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)

                Text("Tasks")
                    .font(.headline)

                NavigationLink(destination: TaskListView(tasks: project.project.tasks)) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("View All Tasks")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }

                Button(action: {
                    isPresentingAddTaskView = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Task")
                    }
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $isPresentingAddTaskView) {
                    AddTaskView(project: project)
                }

                ForEach(project.project.tasks) { task in
                    TaskRowView(task: task, toggleCompletion: {
                        viewModel.toggleTaskCompletion(for: projectIndex, taskID: task.id)
                    })
                }

                Text("Expenses")
                    .font(.headline)
                ForEach(project.project.expenses) { expense in
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

// MARK: - Preview
struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample Task
        let sampleTasks = [
            Task(title: "Task 1", isCompleted: false, durationInDays: 5, priority: .high),
            Task(title: "Task 2", isCompleted: true, durationInDays: 3, priority: .medium),
            Task(title: "Task 3", isCompleted: false, durationInDays: 7, priority: .low)
        ]

        // Sample Project
        let sampleProject = Project(
            name: "Sample Project",
            description: "This is a sample project for preview purposes.",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 30), // 30 days later
            budget: 5000.0,
            tasks: sampleTasks,
            expenses: []
        )

        // Sample ViewModel
        let sampleProjectViewModel = ProjectViewModel(project: sampleProject)
        let sampleProjectListViewModel = ProjectListViewModel()

        return NavigationView {
            ProjectDetailView(
                project: sampleProjectViewModel,
                viewModel: sampleProjectListViewModel,
                projectIndex: 0
            )
        }
    }
}