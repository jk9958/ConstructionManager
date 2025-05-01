import SwiftUI

struct TaskListView: View {
    var project: Project
    @State private var tasks: [Task] = []
    @State private var isAddingTask = false

    var body: some View {
        NavigationView {
            VStack {
                if tasks.isEmpty {
                    // Show a placeholder message when the task list is empty
                    VStack {
                        Text("No tasks available for this project.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                        Button(action: {
                            isAddingTask = true
                        }) {
                            Label("Add Task", systemImage: "plus")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    // Show the list of tasks
                    List {
                        ForEach(tasks) { task in
                            TaskRowView(
                                task: task,
                                toggleCompletion: { toggleTaskCompletion(task) },
                                updateStatus: { newStatus in updateTaskStatus(task, to: newStatus) }
                            )
                        }
                        .onDelete(perform: deleteTask)
                    }
                }
            }
            .navigationTitle("\(project.name ?? "Project") Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingTask = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingTask) {
                AddTaskView(project: project)
            }
            .onAppear {
                loadTasks()
            }
        }
    }

    private func loadTasks() {
        tasks = CoreDataManager.shared.fetchTasks(forProjectId: project.id)
    }

    private func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            CoreDataManager.shared.saveContext()
        }
    }

    private func updateTaskStatus(_ task: Task, to newStatus: TaskStatus) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].status = newStatus
            CoreDataManager.shared.saveContext()
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            CoreDataManager.shared.deleteTask(task)
            tasks.remove(at: index)
        }
    }
}
