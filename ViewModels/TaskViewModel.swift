import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [
        Task(title: "Foundation", isCompleted: false, durationInDays: 5, assignedTo: "John", priority: .high, deadline: nil),
        Task(title: "Framing", isCompleted: false, durationInDays: 10, assignedTo: "Alice", priority: .medium, deadline: nil),
        Task(title: "Roofing", isCompleted: false, durationInDays: 7, assignedTo: nil, priority: .low, deadline: nil)
    ]

    func updateTask(at index: Int, title: String, assignedTo: String?, priority: TaskPriority, deadline: Date?) {
        guard tasks.indices.contains(index) else { return }
        tasks[index].title = title
        tasks[index].assignedTo = assignedTo
        tasks[index].priority = priority
        tasks[index].deadline = deadline
    }

    func toggleTaskCompletion(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks[index].isCompleted.toggle()
    }
}