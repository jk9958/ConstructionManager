import SwiftUI

struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var expenses: [Expense]

    @State private var title: String = ""
    @State private var expenseDescription: String = ""
    @State private var amount: Double = 0.0
    @State private var category: String = "Miscellaneous"
    @State private var date: Date = Date()

    let categories = ["Materials", "Labor", "Equipment", "Miscellaneous"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $expenseDescription)
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    TextField("Amount", value: $amount, formatter: NumberFormatter.currency)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Date")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationBarTitle("Add Expense", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveExpense()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }

    private func saveExpense() {
        let newExpense = Expense(
            id: UUID(),
            title: title,
            expenseDescription: expenseDescription,
            amount: amount,
            category: category,
            date: date,
            status: "Pending",
            submittedBy: "Current User", // Replace with actual user data if available
            receiptURL: nil,
            createdAt: Date(),
            updatedAt: nil
        )
        expenses.append(newExpense)
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    @State static var expenses: [Expense] = []

    static var previews: some View {
        AddExpenseView(expenses: $expenses)
    }
}
