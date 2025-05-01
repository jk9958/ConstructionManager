struct DocumentPermission: Identifiable {
    var userId: UUID
    var accessLevel: String
    var grantedAt: Date
    var expiresAt: Date?
}