import Foundation

struct Project: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var startDate: Date
    var endDate: Date
    var budget: Double
    var tasks: [Task]
    var expenses: [Expense]
}