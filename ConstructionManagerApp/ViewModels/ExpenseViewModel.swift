import Foundation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []

    init() {
        // Load initial data or fetch from CoreData if needed
        loadExpenses()
    }

    func loadExpenses() {
        // Example: Load mock data or integrate with CoreDataManager
        expenses = [
            Expense(
                id: UUID(),
                title: "Cement purchase",
                expenseDescription: "Purchased cement for foundation work",
                amount: 200.0,
                category: "Materials",
                date: Date(),
                status: "Approved",
                submittedBy: "John Doe",
                receiptURL: nil,
                createdAt: Date(),
                updatedAt: nil
            ),
            Expense(
                id: UUID(),
                title: "Equipment rental",
                expenseDescription: "Rented excavator for site preparation",
                amount: 150.0,
                category: "Equipment",
                date: Date(),
                status: "Pending",
                submittedBy: "Jane Smith",
                receiptURL: nil,
                createdAt: Date(),
                updatedAt: nil
            )
        ]
    }

    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        // Save to CoreData if needed
    }

    func removeExpense(at index: Int) {
        expenses.remove(at: index)
        // Remove from CoreData if needed
    }

    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
            // Update in CoreData if needed
        }
    }
}
