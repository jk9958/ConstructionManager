struct DocumentActivity: Identifiable {
    var id: UUID
    var activityType: String?
    var timestamp: Date?
    var userId: UUID?
}