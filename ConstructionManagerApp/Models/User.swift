import Foundation

struct Preferences: Codable {
    var theme: String?
    var notificationsEnabled: Bool?
}

struct User: Identifiable, Equatable {
    var id = UUID()
    var displayName: String?
    var email: String?
    var role: String?
    var department: String?
    var jobTitle: String?
    var phoneNumber: String?
    var status: String?
    var preferences: NSObject? // Exclude this from Codable
    var createdAt: Date?
    var updatedAt: Date?
    var lastLoginAt: Date?
    var assignedTasks: [Task]?
    var teams: [Team]?

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

// Extend User to conform to Codable, excluding `preferences`
extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case email
        case role
        case department
        case jobTitle
        case phoneNumber
        case status
        case createdAt
        case updatedAt
        case lastLoginAt
        case assignedTasks
        case teams
    }
}
