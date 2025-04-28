import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var filter: TaskFilter = .all
    @State private var selectedPriority: TaskPriority = .all

    enum TaskFilter {
        case all, completed, pending
    }

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
        }
        .padding()
    }

    // MARK: - Task List View
    private var taskListView: some View {
        VStack {
            filterPickers
            List {
                ForEach($viewModel.tasks, id: \.id) { $task in
                    if (selectedPriority == .all || task.priority == selectedPriority) &&
                        (filter == .all || (filter == .completed && task.isCompleted) || (filter == .pending && !task.isCompleted)) {
                        
                        NavigationLink(
                            destination: EditTaskView(viewModel: viewModel, taskIndex: viewModel.tasks.firstIndex(where: { $0.id == task.id })!)
                        ) {
                            TaskRowView(
                                task: task, // Use the `Binding<Task>` directly
                                toggleCompletion: {
                                    if let taskIndex = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                        viewModel.toggleTaskCompletion(at: taskIndex)
                                    }
                                }
                            )
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                if let taskIndex = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                    viewModel.removeTask(at: taskIndex)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Filter Pickers
    private var filterPickers: some View {
        VStack {
            Picker("Filter", selection: $filter) {
                Text("All").tag(TaskFilter.all)
                Text("Completed").tag(TaskFilter.completed)
                Text("Pending").tag(TaskFilter.pending)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Picker("Priority", selection: $selectedPriority) {
                ForEach(TaskPriority.allCases, id: \.self) { priority in
                    Text(priority.rawValue).tag(priority)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}