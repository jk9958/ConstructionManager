import SwiftUI

struct EditExpenseView: View {
    @Binding var expense: Expense?
    var onSave: (Expense) -> Void

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: Double = 0.0
    @State private var category: String = "Miscellaneous"
    @State private var date: Date = Date()

    let categories = ["Materials", "Labor", "Equipment", "Miscellaneous"]

    var body: some View {
        NavigationStack {
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
            .navigationTitle("Edit Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { expense = nil }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                        expense = nil
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .onAppear { loadExpenseDetails() }
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
        guard var updated = expense else { return }
        updated.title = title
        updated.expenseDescription = description
        updated.amount = amount
        updated.category = category
        updated.date = date
        updated.updatedAt = Date()
        onSave(updated)
    }
}
