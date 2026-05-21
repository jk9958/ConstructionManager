import SwiftUI

struct ExpenseListView: View {
    @State private var expenses: [Expense] = []
    @State private var isAddingExpense = false
    @State private var selectedExpense: Expense? = nil

    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    Button(action: {
                        selectedExpense = expense
                    }) {
                        ExpenseRowView(expense: expense)
                            .listRowBackground(Color.appBackground)
                    }
                }
                .onDelete(perform: deleteExpense)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingExpense = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingExpense) {
                AddExpenseView(expenses: $expenses)
            }
            .sheet(item: $selectedExpense) { expense in
                EditExpenseView(expense: $selectedExpense) { updated in
                    if let index = expenses.firstIndex(where: { $0.id == updated.id }) {
                        expenses[index] = updated
                    }
                    CoreDataManager.shared.createExpense(from: updated, for: nil)
                    selectedExpense = nil
                }
            }
        }
    }

    private func deleteExpense(at offsets: IndexSet) {
        for index in offsets {
            CoreDataManager.shared.deleteExpense(expenses[index])
        }
        expenses.remove(atOffsets: offsets)
    }
}

#Preview {
    ThemedPreview(theme: .brand) {
        ExpenseListView()
    }
}
