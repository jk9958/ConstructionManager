import Foundation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = [
        Expense(description: "Cement purchase", amount: 200.0, date: Date()),
        Expense(description: "Equipment rental", amount: 150.0, date: Date())
    ]

    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }

    func removeExpense(at index: Int) {
        expenses.remove(at: index)
    }
}
