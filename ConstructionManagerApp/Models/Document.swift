import Foundation

struct Document: Identifiable, Codable {
    var id: UUID
    var name: String
    var documentDescription: String?
    var documentType: String?
    var data: Data?
    var updatedAt: Date?
    var activities: [DocumentActivity]? // Relationship to DocumentActivity
    var permissions: [DocumentPermission]? // Relationship to DocumentPermission
}
