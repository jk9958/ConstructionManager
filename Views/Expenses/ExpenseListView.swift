import SwiftUI

struct ExpenseListView: View {
    @StateObject private var viewModel = ExpenseViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.expenses.isEmpty {
                    VStack {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No expenses yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.expenses.indices, id: \.self) { index in
                            ExpenseRowView(expense: viewModel.expenses[index])
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { viewModel.removeExpense(at: $0) }
                        }
                    }
                    .padding()
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddExpenseView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseListView()
    }
}