import Foundation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var errorMessage: String?

    /// When set, the view model is scoped to a single project's expenses.
    /// When `nil`, it manages every expense in the store.
    private let projectId: UUID?

    init(projectId: UUID? = nil) {
        self.projectId = projectId
        loadExpenses()
    }

    /// Total amount across the currently loaded expenses.
    var total: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    func loadExpenses() {
        let projectEntity = projectId.flatMap { CoreDataManager.shared.fetchProject($0) }
        expenses = CoreDataManager.shared.fetchExpenses(for: projectEntity)
            .sorted { $0.date > $1.date }
    }

    func addExpense(_ expense: Expense) {
        let projectEntity = projectId.flatMap { CoreDataManager.shared.fetchProject($0) }
        CoreDataManager.shared.createExpense(from: expense, for: projectEntity)
        loadExpenses()
    }

    func updateExpense(_ expense: Expense) {
        // `createExpense` uses fetch-or-create, so it doubles as an update.
        let projectEntity = projectId.flatMap { CoreDataManager.shared.fetchProject($0) }
        CoreDataManager.shared.createExpense(from: expense, for: projectEntity)
        loadExpenses()
    }

    func removeExpense(at offsets: IndexSet) {
        for index in offsets where expenses.indices.contains(index) {
            CoreDataManager.shared.deleteExpense(expenses[index])
        }
        loadExpenses()
    }
}
