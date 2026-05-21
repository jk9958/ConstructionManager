import SwiftUI

struct ExpenseRowView: View {
    var expense: Expense

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DS.s) {
                Text(expense.title)
                    .font(DS.body)
                    .foregroundColor(.primary)
                Text(expense.expenseDescription ?? "No description available")
                    .font(DS.caption)
                    .foregroundColor(DS.dim(0.6))
            }
            Spacer()
            Text("$\(expense.amount, specifier: "%.2f")")
                .font(DS.subtitle)
                .foregroundColor(.appAccent)
        }
        .padding(DS.m)
        .background(Color.appCard)
        .cornerRadius(DS.cornerRadius)
    }
}

#Preview {
    ThemedPreview(theme: .brand) {
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
