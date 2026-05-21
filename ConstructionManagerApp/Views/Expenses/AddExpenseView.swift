import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var expenses: [Expense]
    var project: Project? = nil

    @State private var title: String = ""
    @State private var expenseDescription: String = ""
    @State private var amount: Double = 0.0
    @State private var category: String = "Miscellaneous"
    @State private var date: Date = Date()

    let categories = ["Materials", "Labor", "Equipment", "Miscellaneous"]

    var body: some View {
        NavigationStack {
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
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExpense()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
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
            submittedBy: "Current User",
            receiptURL: nil,
            createdAt: Date(),
            updatedAt: nil
        )
        expenses.append(newExpense)
        let projectEntity = project.flatMap { CoreDataManager.shared.fetchProject($0.id) }
        CoreDataManager.shared.createExpense(from: newExpense, for: projectEntity)
    }
}
