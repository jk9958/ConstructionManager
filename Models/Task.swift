import Foundation

struct Task: Identifiable, Codable, Equatable {
    var id = UUID()
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

    // Computed property for completion percentage
    var completionPercentage: Double {
        guard durationInDays > 0 else { return 0.0 }
        return isCompleted ? 100.0 : 0.0
    }

    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }

    mutating func toggleCompletion() {
        isCompleted.toggle()
    }
}

enum TaskPriority: String, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

enum TaskStatus: String, CaseIterable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
}