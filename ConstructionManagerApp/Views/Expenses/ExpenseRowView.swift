import SwiftUI

struct ExpenseRowView: View {
    var expense: Expense

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                    .font(.headline)
                Text(expense.expenseDescription ?? "No description available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("$\(expense.amount, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
}

struct ExpenseRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRowView(
            expense: Expense(
                id: UUID(),
                title: "Sample Expense",
                expenseDescription: "This is a sample expense for testing purposes.",
                amount: 100.0,
                category: "Miscellaneous",
                date: Date(),
                status: "Approved",
                submittedBy: "John Doe",
                receiptURL: nil,
                createdAt: Date(),
                updatedAt: nil
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
