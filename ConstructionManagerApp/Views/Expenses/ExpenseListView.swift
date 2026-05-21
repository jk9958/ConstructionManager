import SwiftUI

struct ExpenseListView: View {
    @StateObject private var viewModel = ExpenseViewModel()
    @State private var isAddingExpense = false
    @State private var selectedExpense: Expense? = nil

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.expenses.isEmpty {
                    ContentUnavailableView(
                        "No Expenses",
                        systemImage: "dollarsign.circle",
                        description: Text("Tap + to record your first expense.")
                    )
                } else {
                    List {
                        Section {
                            ForEach(viewModel.expenses) { expense in
                                Button(action: {
                                    selectedExpense = expense
                                }) {
                                    ExpenseRowView(expense: expense)
                                }
                                .listRowBackground(Color.appBackground)
                            }
                            .onDelete(perform: viewModel.removeExpense)
                        } footer: {
                            Text("Total: \(viewModel.total, format: .currency(code: "USD"))")
                                .font(DS.subtitle)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingExpense = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Expense")
                }
            }
            .sheet(isPresented: $isAddingExpense, onDismiss: {
                viewModel.loadExpenses()
            }) {
                AddExpenseView(expenses: $viewModel.expenses)
            }
            .sheet(item: $selectedExpense) { _ in
                EditExpenseView(expense: $selectedExpense) { updated in
                    viewModel.updateExpense(updated)
                    selectedExpense = nil
                }
            }
            .onAppear { viewModel.loadExpenses() }
        }
    }
}

#Preview {
    ThemedPreview(theme: .brand) {
        ExpenseListView()
    }
}
