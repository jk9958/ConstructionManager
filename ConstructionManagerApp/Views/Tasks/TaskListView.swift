import SwiftUI

struct TaskListView: View {
    var project: Project
    @State private var tasks: [Task] = []
    @State private var isAddingTask = false
    @State private var showErrorAlert = false
    @State private var alertMessage: String? = nil

    var body: some View {
        NavigationStack {
            Group {
                if tasks.isEmpty {
                    VStack(spacing: DS.m) {
                        Text("No tasks available for this project.")
                            .font(DS.subtitle)
                            .foregroundColor(DS.dim(0.6))
                            .padding(DS.m)
                        Button(action: {
                            isAddingTask = true
                        }) {
                            Label("Add Task", systemImage: "plus")
                                .font(DS.subtitle)
                                .padding(.vertical, DS.m)
                                .padding(.horizontal, DS.l)
                                .background(Color.appAccent)
                                .foregroundColor(.white)
                                .cornerRadius(DS.cornerRadius)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.appBackground)
                } else {
                    List {
                        ForEach(tasks) { task in
                            TaskRowView(
                                task: task,
                                toggleCompletion: { toggleTaskCompletion(task) },
                                updateStatus: { newStatus in updateTaskStatus(task, to: newStatus) }
                            )
                            .listRowBackground(Color.appBackground)
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(Color.appBackground)
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
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Update Failed"), message: Text(alertMessage ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
        }
    }

    private func loadTasks() {
        tasks = CoreDataManager.shared.fetchTasks(forProjectId: project.id)
    }

    private func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            let success = CoreDataManager.shared.updateTask(tasks[index])
            if !success {
                // revert local change if persistence failed
                tasks[index].isCompleted.toggle()
                alertMessage = "Failed to update task completion. Please try again."
                showErrorAlert = true
            }
        }
    }

    private func updateTaskStatus(_ task: Task, to newStatus: TaskStatus) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            let previous = tasks[index].status
            tasks[index].status = newStatus
            let success = CoreDataManager.shared.updateTask(tasks[index])
            if !success {
                tasks[index].status = previous
                alertMessage = "Failed to update task status. Please try again."
                showErrorAlert = true
            }
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
