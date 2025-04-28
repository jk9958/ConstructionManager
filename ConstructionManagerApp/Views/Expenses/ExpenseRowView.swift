import SwiftUI

struct ExpenseRowView: View {
    var expense: Expense

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(expense.description)
                    .font(.headline)
                Text("$\(expense.amount, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Text(expense.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "creditcard.fill")
                .foregroundColor(.green)
                .font(.title2)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
        .animation(.easeInOut, value: expense.amount) // Add animation for smooth updates
    }
}

struct ExpenseRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRowView(
            expense: Expense(description: "Sample Expense", amount: 100.0, date: Date())
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
