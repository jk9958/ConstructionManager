import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel() // ViewModel manages tasks

    var body: some View {
        NavigationView {
            Group {
                if viewModel.tasks.isEmpty {
                    emptyStateView
                } else {
                    taskListView
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTaskView(viewModel: viewModel)) {
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
            ForEach(viewModel.tasks) { task in
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
        TaskListView()
    }
}