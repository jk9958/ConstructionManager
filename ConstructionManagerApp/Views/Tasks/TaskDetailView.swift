import SwiftUI

struct TaskDetailView: View {
    @State var task: Task
    @State private var isEditingTask = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.l) {
                Text(task.title)
                    .font(DS.title)
                    .fontWeight(.bold)

                if let description = task.taskDescription, !description.isEmpty {
                    Text(description)
                        .font(DS.body)
                        .foregroundColor(DS.theme.secondaryText)
                } else {
                    Text("No description available.")
                        .font(DS.body)
                        .foregroundColor(DS.theme.secondaryText)
                }

                VStack(alignment: .leading, spacing: DS.s) {
                    detailRow(title: "Priority:", value: task.priority.rawValue.capitalized)
                    detailRow(title: "Status:", value: task.status.rawValue.capitalized)
                    detailRow(title: "Deadline:", value: task.deadline?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
                    detailRow(title: "Start Date:", value: task.startDate.formatted(date: .abbreviated, time: .omitted))
                    detailRow(title: "Duration:", value: "\(task.durationInDays) days")
                }
                .padding(DS.m)
                .background(Color.appCard)
                .cornerRadius(DS.cornerRadius)

                HStack {
                    Text("Completed:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(task.isCompleted ? "Yes" : "No")
                        .foregroundColor(task.isCompleted ? Color.appSuccess : Color.appDanger)
                }
                .padding(DS.m)
                .background(Color.appCard)
                .cornerRadius(DS.cornerRadius)
            }
            .padding(DS.l)
            .background(Color.appBackground)
        }
        .navigationTitle("Task Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isEditingTask = true
                }) {
                    Text("Edit")
                }
            }
        }
        .sheet(isPresented: $isEditingTask) {
            EditTaskView(task: $task)
        }
        .onChange(of: isEditingTask) {
            if !isEditingTask {
                refreshTask()
            }
        }
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

    private func refreshTask() {
        task = CoreDataManager.shared.fetchTasks().first(where: { $0.id == self.task.id }) ?? self.task 
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(
            task: Task(
                id: UUID(),
                title: "Excavation",
                taskDescription: "Excavate the site for foundation work.",
                isCompleted: false,
                durationInDays: 5,
                assignedTo: [],
                priority: .high,
                deadline: Date().addingTimeInterval(86400 * 7),
                status: .inProgress,
                startDate: Date(),
                createdAt: Date(),
                updatedAt: nil
            )
        )
    }
}
