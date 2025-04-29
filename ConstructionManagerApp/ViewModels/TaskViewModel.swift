import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [
        Task(title: "Foundation", isCompleted: false, durationInDays: 5, assignedTo: "John", priority: .high, deadline: nil, startDate: Date()),
        Task(title: "Framing", isCompleted: false, durationInDays: 10, assignedTo: "Alice", priority: .medium, deadline: nil, startDate: Date()),
        Task(title: "Roofing", isCompleted: false, durationInDays: 7, assignedTo: nil, priority: .low, deadline: nil, startDate: Date())
    ]

    init(tasks: [Task] = []) {
        self.tasks = tasks
    }

    func updateTask(at index: Int, title: String, assignedTo: String?, priority: TaskPriority, deadline: Date?) {
        guard tasks.indices.contains(index) else { return }
        tasks[index].title = title
        tasks[index].assignedTo = assignedTo
        tasks[index].priority = priority
        tasks[index].deadline = deadline
    }
    
    func addTask(title: String, assignedTo: String?, priority: TaskPriority, deadline: Date?) {
            let newTask = Task(
                title: title,
                isCompleted: false,
                durationInDays: 0, // Default value, can be updated later
                assignedTo: assignedTo,
                priority: priority,
                deadline: deadline,
                startDate: Date()
            )
            tasks.append(newTask)
        }
    
    func toggleTaskCompletion(task id: UUID) {
        guard  let index = tasks.indices.filter({ tasks[$0].id == id }).first else { return }
        tasks[index].isCompleted.toggle()
    }
    
    func updateStatus(ofTask id: UUID, status: TaskStatus) {
        guard  let index = tasks.indices.filter({ tasks[$0].id == id }).first else { return }
        tasks[index].status = status
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
