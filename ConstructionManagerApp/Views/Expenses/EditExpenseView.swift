import SwiftUI

struct EditExpenseView: View {
    @Binding var expense: Expense?

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: Double = 0.0
    @State private var category: String = "Miscellaneous"
    @State private var date: Date = Date()

    let categories = ["Materials", "Labor", "Equipment", "Miscellaneous"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
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
            .navigationBarTitle("Edit Expense", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    expense = nil
                },
                trailing: Button("Save") {
                    saveChanges()
                    expense = nil
                }
            )
            .onAppear {
                loadExpenseDetails()
            }
        }
    }

    private func loadExpenseDetails() {
        guard let expense = expense else { return }
        title = expense.title
        description = expense.expenseDescription ?? ""
        amount = expense.amount
        category = expense.category
        date = expense.date
    }

    private func saveChanges() {
        guard var expense = expense else { return }
        expense.title = title
        expense.expenseDescription = description
        expense.amount = amount
        expense.category = category
        expense.date = date
    }
}
