import Foundation
import Foundation

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
    
    var progress: Double {
           guard !tasks.isEmpty else { return 0.0 }
           let completedTasks = tasks.filter { $0.isCompleted }.count
           return Double(completedTasks) / Double(tasks.count)
       }
}

struct Expense: Identifiable {
    var id = UUID() // Unique identifier for each expense
    var description: String
    var amount: Double
    var date: Date
    
    init(description: String, amount: Double, date: Date) {
        self.description = description
        self.amount = amount
        self.date = date
    }
}
