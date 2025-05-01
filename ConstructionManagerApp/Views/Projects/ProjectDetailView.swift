import SwiftUI

struct ProjectDetailView: View {
    @State var project: Project
    @State private var isAddingTask = false
    @State private var tasks: [Task] = []
    @State private var selectedTask: Task? = nil // State to track the selected task

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                projectHeader
                projectDetails
                projectDates
                tasksSection
                expensesSection
            }
            .padding()
        }
        .navigationTitle("Project Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isAddingTask = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddingTask, onDismiss: {
            refreshTasks()
        }) {
            AddTaskView(project: project)
        }
        .onAppear {
            refreshTasks()
        }
    }

    // MARK: - Components

    private var projectHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(project.name ?? "Untitled Project")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(project.projectDescription ?? "No description available")
                .font(.body)
                .foregroundColor(.gray)
        }
    }

    private var projectDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            detailRow(title: "Priority:", value: project.priority ?? "N/A")
            detailRow(title: "Status:", value: project.status ?? "N/A")
            detailRow(title: "Budget:", value: String(format: "$%.2f", project.budget)) // Format the budget
            detailRow(title: "Location:", value: project.location ?? "N/A")
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }

    private var projectDates: some View {
        VStack(alignment: .leading, spacing: 8) {
            detailRow(title: "Start Date:", value: project.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
            detailRow(title: "Expected End Date:", value: project.expectedEndDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }

    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tasks")
                .font(.headline)
            if tasks.isEmpty {
                VStack {
                    Text("No tasks available.")
                        .foregroundColor(.gray)
                        .padding()
                    Button(action: {
                        isAddingTask = true
                    }) {
                        Label("Add Task", systemImage: "plus")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            } else {
                ForEach(tasks) { task in
                    NavigationLink(
                        destination: TaskDetailView(task: task),
                        tag: task,
                        selection: $selectedTask
                    ) {
                        TaskRowView(
                            task: task,
                            toggleCompletion: {
                                toggleTaskCompletion(task: task)
                            },
                            updateStatus: { newStatus in
                                updateTaskStatus(task: task, to: newStatus)
                            }
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }

    private var expensesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Expenses")
                .font(.headline)
            if let expenses = project.expenses, !expenses.isEmpty {
                ForEach(expenses) { expense in
                    HStack {
                        Text(expense.title)
                        Spacer()
                        Text("$\(expense.amount, specifier: "%.2f")")
                            .font(.caption)
                    }
                }
            } else {
                Text("No expenses available.")
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }

    // MARK: - Helper Methods

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
        }
    }

    private func refreshTasks() {
        tasks = CoreDataManager.shared.fetchTasks(forProjectId: project.id)
    }

    private func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle() // Toggle the completion status
            CoreDataManager.shared.updateTask(tasks[index]) // Save the updated task to Core Data
        }
    }

    private func updateTaskStatus(task: Task, to newStatus: TaskStatus) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].status = newStatus // Update the task status
            CoreDataManager.shared.updateTask(tasks[index]) // Save the updated task to Core Data
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
