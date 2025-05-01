import Foundation

struct Team: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String?
    var createdAt: Date?
    var createdBy: UUID?
    var updatedAt: Date?
    var members: [User]? // Relationship to User
    var projects: [Project]? // Relationship to Project

    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id
    }
}