import Foundation

struct Project: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String?
    var projectDescription: String?
    var priority: ProjectPriority?
    var status: ProjectStatus?
    var budget: Double
    var location: String?
    var startDate: Date?
    var expectedEndDate: Date?
    var createdAt: Date?
    var updatedAt: Date?
    var documents: [Document]?
    var expenses: [Expense]?
    var tasks: [Task]?
    var team: Team?

    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
}

enum ProjectPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum ProjectStatus: String, CaseIterable, Codable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
}
