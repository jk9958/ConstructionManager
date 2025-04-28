
import Foundation

struct Task: Identifiable, Codable, Equatable  {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var durationInDays: Int
    var assignedTo: String?
    var priority: TaskPriority
    var deadline: Date?
    // Custom implementation of the equality operator
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
    
    mutating func toggleCompletion() {
        isCompleted.toggle()
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
