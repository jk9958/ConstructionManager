import Foundation

struct Expense: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String // Add this property
    var expenseDescription: String?
    var amount: Double
    var category: String
    var date: Date
    var status: String
    var submittedBy: String
    var receiptURL: String?
    var createdAt: Date
    var updatedAt: Date?

    static func == (lhs: Expense, rhs: Expense) -> Bool {
        return lhs.id == rhs.id
    }
}
