import SwiftUI

struct TaskDetailView: View {
    var task: Task

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Task Title
                Text(task.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Task Description
                if let description = task.taskDescription, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.gray)
                } else {
                    Text("No description available.")
                        .font(.body)
                        .foregroundColor(.gray)
                }

                // Task Details
                VStack(alignment: .leading, spacing: 8) {
                    detailRow(title: "Priority:", value: task.priority.rawValue.capitalized)
                    detailRow(title: "Status:", value: task.status.rawValue.capitalized)
                    detailRow(title: "Deadline:", value: task.deadline?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
                    detailRow(title: "Start Date:", value: task.startDate.formatted(date: .abbreviated, time: .omitted))
                    detailRow(title: "Duration:", value: "\(task.durationInDays) days")
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)

                // Completion Status
                HStack {
                    Text("Completed:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(task.isCompleted ? "Yes" : "No")
                        .foregroundColor(task.isCompleted ? .green : .red)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Task Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Add any edit functionality here if needed
                }) {
                    Text("Edit")
                }
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
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
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
}