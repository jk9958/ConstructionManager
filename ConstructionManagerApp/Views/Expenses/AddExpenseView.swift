import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel

    @State private var description: String = ""
    @State private var amount: String = ""

    var body: some View {
        Form {
            Section(header: Text("Expense Details")) {
                TextField("Description", text: $description)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            }

            Button(action: {
                if let amountValue = Double(amount) {
                    let newExpense = Expense(description: description, amount: amountValue, date: Date())
                    viewModel.addExpense(newExpense)
                }
            }) {
                Text("Add Expense")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .navigationTitle("Add Expense")
        .padding()
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(viewModel: ExpenseViewModel())
    }
}
