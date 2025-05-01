import SwiftUI

struct ExpenseListView: View {
    @State private var expenses: [Expense] = []
    @State private var isAddingExpense = false
    @State private var selectedExpense: Expense? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses) { expense in
                    Button(action: {
                        selectedExpense = expense
                    }) {
                        ExpenseRowView(expense: expense)
                    }
                }
                .onDelete(perform: deleteExpense)
            }
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
                EditExpenseView(expense: $selectedExpense)
            }
        }
    }

    private func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
        // Optionally, delete from Core Data or backend
    }
}

struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseListView()
    }
}
