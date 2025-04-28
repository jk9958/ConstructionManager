import SwiftUI

struct ExpenseListView: View {
    @StateObject private var viewModel = ExpenseViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) { // Use LazyVStack for better performance
                    ForEach(viewModel.expenses.indices, id: \.self) { index in
                        ExpenseRowView(expense: viewModel.expenses[index])
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { viewModel.removeExpense(at: $0) }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground)) // Add background color
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

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskViewModel

    @State private var title: String = ""
    @State private var assignedTo: String = ""
    @State private var priority: TaskPriority = .medium
    @State private var deadline: Date = Date()

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $title)
                    TextField("Assigned To", text: $assignedTo)
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                }

                Button("Add Task") {
                    viewModel.addTask(
                        title: title,
                        assignedTo: assignedTo.isEmpty ? nil : assignedTo,
                        priority: priority,
                        deadline: deadline
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add Task")
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(viewModel: TaskViewModel())
    }
}
