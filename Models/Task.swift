import Foundation

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var durationInDays: Int
    var assignedTo: String? // New property for task assignment
    var priority: TaskPriority // New property for priority level
    var deadline: Date? // Optional deadline for scheduling
}

enum TaskPriority: String, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}