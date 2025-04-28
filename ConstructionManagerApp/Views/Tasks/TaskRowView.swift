import SwiftUI

struct TaskRowView: View {
    var task: Task
    var toggleCompletion: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                if let assignedTo = task.assignedTo {
                    Text("Assigned to: \(assignedTo)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Text("Priority: \(task.priority.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(priorityColor(for: task.priority))
                Text("Duration: \(task.durationInDays) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: toggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .contentShape(Rectangle()) // Ensures the button is fully tappable
            .accessibilityLabel(task.isCompleted ? "Mark as incomplete" : "Mark as complete")
        }
        .padding(.vertical, 8)
    }

    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(
            task: Task(
                title: "Inspect foundation",
                isCompleted: false,
                durationInDays: 3,
                assignedTo: "John Doe", priority: .high
            ),
            toggleCompletion: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
