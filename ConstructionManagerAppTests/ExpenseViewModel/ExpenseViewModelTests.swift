import XCTest
@testable import ConstructionManagerApp

final class ExpenseViewModelTests: XCTestCase {

    func testExpenseViewModel_loadsAndModifiesExpenses() {
        let viewModel = ExpenseViewModel()
        XCTAssertEqual(viewModel.expenses.count, 2, "ExpenseViewModel should start with two sample expenses")

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
        XCTAssertEqual(viewModel.expenses.count, 3)
        XCTAssertEqual(viewModel.expenses.last?.id, newExpense.id)

        var updatedExpense = newExpense
        updatedExpense.amount = 55.75
        viewModel.updateExpense(updatedExpense)
        XCTAssertEqual(viewModel.expenses.last?.amount, 55.75)

        viewModel.removeExpense(at: 0)
        XCTAssertEqual(viewModel.expenses.count, 2)
    }
}
