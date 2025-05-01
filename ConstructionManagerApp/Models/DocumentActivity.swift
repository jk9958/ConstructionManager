import Foundation

struct DocumentActivity: Identifiable, Codable {
    var id: UUID
    var activityType: String?
    var timestamp: Date?
    var userId: UUID?
}
