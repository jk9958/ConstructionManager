import Foundation


struct DocumentPermission: Identifiable, Codable {
    var id: UUID
    var userId: UUID
    var accessLevel: String
    var grantedAt: Date
    var expiresAt: Date?
}
