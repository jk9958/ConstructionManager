import Foundation

struct Project: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String?
    var projectDescription: String?
    var priority: String?
    var status: String?
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
