import SwiftUI

struct TaskListView: View {
    var project: Project
    @State private var tasks: [Task] = []
    @State private var isAddingTask = false
    @State private var selectedTask: Task? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    Button(action: {
                        selectedTask = task
                    }) {
                        TaskRowView(
                            task: task,
                            toggleCompletion: { toggleTaskCompletion(task) },
                            updateStatus: { newStatus in updateTaskStatus(task, to: newStatus) }
                        )
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("Tasks")
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
                AddTaskView(tasks: $tasks)
            }
            .sheet(item: $selectedTask) { task in
                EditTaskView(task: $selectedTask, project: project) // Pass the project here
            }
        }
    }

    private func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    private func updateTaskStatus(_ task: Task, to newStatus: TaskStatus) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].status = newStatus
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        // Optionally, delete from Core Data or backend
    }
}
