import XCTest
@testable import ConstructionManagerApp

final class ExpenseViewModelTests: XCTestCase {

    func testExpenseViewModel_loadsAndModifiesExpenses() {
        let viewModel = ExpenseViewModel()
        let initialCount = viewModel.expenses.count

        let newExpense = Expense(
            id: UUID(),
            title: "Test Materials",
            expenseDescription: "Test expense description",
            amount: 42.50,
            category: "Materials",
            date: Date(),
            status: "Pending",
            submittedBy: "Test User",
            receiptURL: nil,
            createdAt: Date(),
            updatedAt: nil
        )

        viewModel.addExpense(newExpense)
        XCTAssertEqual(viewModel.expenses.count, initialCount + 1)
        XCTAssertTrue(viewModel.expenses.contains { $0.id == newExpense.id })

        var updatedExpense = newExpense
        updatedExpense.amount = 55.75
        viewModel.updateExpense(updatedExpense)
        XCTAssertEqual(viewModel.expenses.first { $0.id == newExpense.id }?.amount, 55.75)

        if let index = viewModel.expenses.firstIndex(where: { $0.id == newExpense.id }) {
            viewModel.removeExpense(at: IndexSet(integer: index))
        }
        XCTAssertFalse(viewModel.expenses.contains { $0.id == newExpense.id })
        XCTAssertEqual(viewModel.expenses.count, initialCount)
    }
}
