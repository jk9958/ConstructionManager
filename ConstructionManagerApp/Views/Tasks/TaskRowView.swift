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
            }
            Spacer()
            Button(action: toggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
        }
    }

    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        case .all: return .gray
        }
    }
}
