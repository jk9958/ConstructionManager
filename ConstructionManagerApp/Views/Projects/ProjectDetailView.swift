import SwiftUI

struct ProjectDetailView: View {
    @State var project: Project
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Project Name and Description
                Text(project.name ?? "Untitled Project")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(project.projectDescription ?? "No description available")
                    .font(.body)
                    .foregroundColor(.gray)

                // Project Details
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Priority:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(project.priority ?? "N/A")
                    }
                    HStack {
                        Text("Status:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(project.status ?? "N/A")
                    }
                    HStack {
                        Text("Budget:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("$\(project.budget, specifier: "%.2f")")
                    }
                    HStack {
                        Text("Location:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(project.location ?? "N/A")
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)

                // Dates
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Start Date:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(project.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
                    }
                    HStack {
                        Text("Expected End Date:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(project.expectedEndDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)

                // Tasks Section
                if let tasks = project.tasks, !tasks.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tasks")
                            .font(.headline)
                        ForEach(tasks) { task in
                            HStack {
                                Text(task.title)
                                Spacer()
                                Text(task.isCompleted ? "Completed" : "Pending")
                                    .foregroundColor(task.isCompleted ? .green : .red)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                } else {
                    Text("No tasks available.")
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                }

                // Expenses Section
                if let expenses = project.expenses, !expenses.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Expenses")
                            .font(.headline)
                        ForEach(expenses) { expense in
                            HStack {
                                Text(expense.title)
                                Spacer()
                                Text("$\(expense.amount, specifier: "%.2f")")
                                    .font(.caption)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                } else {
                    Text("No expenses available.")
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Project Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditProjectView(project: $project)
        }
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectDetailView(
                project: Project(
                    id: UUID(),
                    name: "Build a House",
                    projectDescription: "Residential construction",
                    priority: "High",
                    status: "In Progress",
                    budget: 50000,
                    location: "New York",
                    startDate: Date(),
                    expectedEndDate: Date().addingTimeInterval(86400 * 30),
                    createdAt: Date(),
                    updatedAt: nil,
                    documents: [],
                    expenses: [
                        Expense(
                            id: UUID(),
                            title: "Cement",
                            expenseDescription: "Purchased cement for foundation work",
                            amount: 20000,
                            category: "Materials",
                            date: Date(),
                            status: "Approved",
                            submittedBy: "John Doe",
                            receiptURL: nil,
                            createdAt: Date(),
                            updatedAt: nil
                        )
                    ],
                    tasks: [
                        Task(
                            id: UUID(),
                            title: "Excavation",
                            taskDescription: "Excavate the site",
                            isCompleted: false,
                            durationInDays: 5,
                            assignedTo: [],
                            priority: .high,
                            deadline: nil,
                            status: .notStarted,
                            startDate: Date(),
                            createdAt: Date(),
                            updatedAt: nil
                        )
                    ],
                    team: nil
                )
            )
        }
    }
}
