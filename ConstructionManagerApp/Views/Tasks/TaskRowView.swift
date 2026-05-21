import SwiftUI

struct TaskRowView: View {
    var task: Task
    var toggleCompletion: () -> Void
    var updateStatus: (TaskStatus) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: DS.m) {
            VStack(alignment: .leading, spacing: DS.s) {
                Text(task.title)
                    .font(DS.title)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                if let assignedTo = task.assignedTo {
                    Text("Assigned to: \(assignedTo)")
                        .font(DS.subtitle)
                        .foregroundColor(DS.dim(0.7))
                }
                Text("Start Date: \(task.startDate, formatter: Self.dateFormatter)")
                    .font(DS.subtitle)
                    .foregroundColor(DS.dim(0.6))
                Text("Priority: \(task.priority.rawValue)")
                    .font(DS.subtitle)
                    .foregroundColor(priorityColor(for: task.priority))
                Text("Duration: \(task.durationInDays) days")
                    .font(DS.subtitle)
                    .foregroundColor(DS.dim(0.6))
            }
            Spacer()
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    toggleCompletion()
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(task.isCompleted ? .appSuccess : .secondary)
                    .scaleEffect(task.isCompleted ? 1.05 : 1.0)
                    .accessibilityLabel(task.isCompleted ? "Mark as incomplete" : "Mark as complete")
                    .accessibilityHint("Toggles task completion")
            }
        }
        .padding(DS.m)
        .background(Color.appCard)
        .cornerRadius(DS.cornerRadius)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        .accessibilityElement(children: .combine)
    }

    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

#Preview {
    TaskRowView(
        task: Task(
            title: "Inspect foundation",
            isCompleted: false,
            durationInDays: 3,
            assignedTo: [UUID()],
            priority: .high,
            deadline: Date().addingTimeInterval(86400 * 5),
            startDate: Date(), createdAt: Date()
        ),
        toggleCompletion: {},
        updateStatus: { _ in }
    )
    .previewLayout(.sizeThatFits)
    .padding()
}
