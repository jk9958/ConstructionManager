import Foundation

enum OfflineOperationType: String, Codable {
    case create
    case update
    case delete
}

struct OfflineOperation: Codable, Identifiable {
    var id: UUID = UUID()
    var type: OfflineOperationType
    var entityName: String
    var payload: Data // JSON payload
    var createdAt: Date = Date()
}
