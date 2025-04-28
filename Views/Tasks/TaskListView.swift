import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    var tasks: [Task] // Accept tasks as a parameter

    init(tasks: [Task] = []) {
        self.tasks = tasks
    }

    var body: some View {
        NavigationView {
            Group {
                if tasks.isEmpty {
                    emptyStateView
                } else {
                    taskListView
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTaskView(project: ProjectViewModel(project: Project(name: "Default Project", description: "", startDate: Date(), endDate: Date(), budget: 0.0, tasks: [], expenses: [])))) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Task")
                        }
                    }
                }
            }
        }
    }

    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "tray")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("No tasks yet")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Tap the '+' button to add your first task.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .padding()
    }

    // MARK: - Task List View
    private var taskListView: some View {
        List {
            ForEach(tasks) { task in
                HStack {
                    TaskRowView(task: task, toggleCompletion: {
                        if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                            viewModel.toggleTaskCompletion(at: index)
                        }
                    })
                    Spacer()
                    Button(action: {
                        if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                            viewModel.removeTask(at: index)
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(tasks: [
            Task(title: "Task 1", isCompleted: false, durationInDays: 5, priority: .high),
            Task(title: "Task 2", isCompleted: true, durationInDays: 3, priority: .medium)
        ])
    }
}