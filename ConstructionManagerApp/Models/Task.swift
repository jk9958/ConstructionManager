import Foundation

struct Task: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var projectId: UUID?
    var title: String
    var taskDescription: String?
    var isCompleted: Bool
    var durationInDays: Int
    var assignedTo: [UUID]?
    var priority: TaskPriority
    var deadline: Date?
    var status: TaskStatus = .notStarted
    var startDate: Date
    var createdAt: Date
    var updatedAt: Date?
    var dependencies: [UUID]?

    var completionPercentage: Double {
        if isCompleted || status == .completed { return 100.0 }
        guard status == .inProgress, let deadline = deadline, deadline > startDate else {
            return status == .notStarted ? 0.0 : 50.0
        }
        let total = deadline.timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(startDate)
        return min(max((elapsed / total) * 100.0, 0.0), 99.0)
    }

    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }

    mutating func toggleCompletion() {
        isCompleted.toggle()
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

enum TaskStatus: String, CaseIterable, Codable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
}
