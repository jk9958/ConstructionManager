import SwiftUI

struct ProjectDetailView: View {
    @State var project: Project
    @State private var isAddingTask = false
    @State private var isAddingExpense = false
    @State private var tasks: [Task] = []
    @State private var expenses: [Expense] = []
    @State private var showErrorAlert = false
    @State private var alertMessage: String? = nil
    @State private var selectedTask: Task? = nil // State to track the selected task

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.l) {
                projectHeader
                projectDetails
                projectDates
                tasksSection
                expensesSection
            }
            .padding(DS.l)
            .background(Color.appBackground)
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    let result = SyncManager.shared.exportAllData()
                    switch result {
                    case .success(let url):
                        alertMessage = "Exported data to: \(url.lastPathComponent)"
                        showErrorAlert = true
                    case .failure(let err):
                        alertMessage = "Export failed: \(err.localizedDescription)"
                        showErrorAlert = true
                    }
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $isAddingTask, onDismiss: {
            refreshTasks()
        }) {
            AddTaskView(project: project)
        }
        .sheet(isPresented: $isAddingExpense, onDismiss: {
            refreshExpenses()
        }) {
            AddExpenseView(expenses: $expenses, project: project)
        }
        .onAppear {
            refreshTasks()
            refreshExpenses()
        }
        .onChange(of: expenses) { newValue in
            project.expenses = newValue
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Update Failed"), message: Text(alertMessage ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - Components

    private var projectHeader: some View {
        VStack(alignment: .leading, spacing: DS.s) {
            Text(project.name ?? "Untitled Project")
                .font(DS.title)
                .fontWeight(.bold)
            Text(project.projectDescription ?? "No description available")
                .font(DS.body)
                .foregroundColor(DS.dim(0.6))
        }
    }

    private var projectDetails: some View {
        VStack(alignment: .leading, spacing: DS.s) {
            detailRow(title: "Priority:", value: project.priority ?? "N/A")
            detailRow(title: "Status:", value: project.status ?? "N/A")
            detailRow(title: "Budget:", value: String(format: "$%.2f", project.budget))
            detailRow(title: "Location:", value: project.location ?? "N/A")
        }
        .padding(DS.m)
        .background(Color.appCard)
        .cornerRadius(DS.cornerRadius)
    }

    private var projectDates: some View {
        VStack(alignment: .leading, spacing: DS.s) {
            detailRow(title: "Start Date:", value: project.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
            detailRow(title: "Expected End Date:", value: project.expectedEndDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
        }
        .padding(DS.m)
        .background(Color.appCard)
        .cornerRadius(DS.cornerRadius)
    }

    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: DS.s) {
            Text("Tasks")
                .font(DS.subtitle)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)
            if tasks.isEmpty {
                VStack(spacing: DS.s) {
                    Text("No tasks available.")
                        .foregroundColor(DS.dim(0.6))
                        .padding(DS.m)
                    Button(action: {
                        isAddingTask = true
                    }) {
                        Label("Add Task", systemImage: "plus")
                            .font(DS.body)
                            .padding(.vertical, DS.m)
                            .padding(.horizontal, DS.l)
                            .background(Color.appAccent)
                            .foregroundColor(.white)
                            .cornerRadius(DS.cornerRadius)
                    }
                }
                .padding(DS.m)
                .background(Color.appCard)
                .cornerRadius(DS.cornerRadius)
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
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityHint("Opens task details")
                }
            }
        }
        .padding(DS.m)
        .background(Color.appCard)
        .cornerRadius(DS.cornerRadius)
    }

    private var expensesSection: some View {
        VStack(alignment: .leading, spacing: DS.s) {
            HStack {
                Text("Expenses")
                    .font(DS.subtitle)
                    .fontWeight(.semibold)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Button(action: {
                    isAddingExpense = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.appAccent)
                        .font(.title3)
                }
                .accessibilityLabel("Add Expense")
            }
            if expenses.isEmpty {
                Text("No expenses available.")
                    .foregroundColor(DS.dim(0.6))
                    .padding(DS.m)
                    .background(Color.appCard)
                    .cornerRadius(DS.cornerRadius)
            } else {
                ForEach(expenses) { expense in
                    HStack {
                        Text(expense.title)
                            .font(DS.body)
                        Spacer()
                        Text("$\(expense.amount, specifier: "%.2f")")
                            .font(DS.caption)
                            .foregroundColor(.appAccent)
                    }
                    .padding(.vertical, DS.s)
                }
            }
        }
        .padding(DS.m)
        .background(Color.appCard)
        .cornerRadius(DS.cornerRadius)
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

    private func refreshExpenses() {
        if let updatedProject = CoreDataManager.shared.fetchProjectModel(project.id) {
            expenses = updatedProject.expenses ?? []
            project.expenses = updatedProject.expenses
        } else {
            expenses = project.expenses ?? []
        }
    }

    private func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle() // Toggle the completion status
            let success = CoreDataManager.shared.updateTask(tasks[index]) // Save the updated task to Core Data
            if !success {
                tasks[index].isCompleted.toggle()
                alertMessage = "Failed to update task completion. Please try again."
                showErrorAlert = true
            }
        }
    }

    private func updateTaskStatus(task: Task, to newStatus: TaskStatus) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            let previous = tasks[index].status
            tasks[index].status = newStatus // Update the task status
            let success = CoreDataManager.shared.updateTask(tasks[index]) // Save the updated task to Core Data
            if !success {
                tasks[index].status = previous
                alertMessage = "Failed to update task status. Please try again."
                showErrorAlert = true
            }
        }
    }

}

#Preview {
    ThemedPreview(theme: .brand) {
        NavigationStack {
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
