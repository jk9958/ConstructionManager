import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []

    init(tasks: [Task] = []) {
        self.tasks = tasks
    }

    func refreshTasks() {
        // Fetch tasks from Core Data or another data source
        tasks = CoreDataManager.shared.fetchTasks()
    }

    func updateTask(at index: Int, title: String, assignedTo: [UUID], priority: TaskPriority, deadline: Date?) {
        guard tasks.indices.contains(index) else { return }
        tasks[index].title = title
        tasks[index].assignedTo = assignedTo
        tasks[index].priority = priority
        tasks[index].deadline = deadline
    }
    
    func addTask(title: String, assignedTo: [UUID], priority: TaskPriority, deadline: Date?) {
        let newTask = Task(
            title: title,
            isCompleted: false,
            durationInDays: 0, // Default value, can be updated later
            assignedTo: assignedTo,
            priority: priority,
            deadline: deadline,
            startDate: Date(),
            createdAt: Date()
        )
        tasks.append(newTask)
    }
    
    func toggleTaskCompletion(task id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted.toggle()
            CoreDataManager.shared.updateTask(tasks[index])
        }
    }
    
    func updateStatus(ofTask id: UUID, status: TaskStatus) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].status = status
            CoreDataManager.shared.updateTask(tasks[index])
        }
    }

    func updateTaskStatus(at index: Int, to newStatus: TaskStatus) {
        guard tasks.indices.contains(index) else { return }
        tasks[index].status = newStatus
    }
    
    func removeTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks.remove(at: index)
    }
}
