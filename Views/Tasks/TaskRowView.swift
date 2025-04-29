import SwiftUI

struct TaskRowView: View {
    var task: Task
    var toggleCompletion: () -> Void
    var updateStatus: (TaskStatus) -> Void

    @State private var isEditingStatus = false

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
                Text("Start Date: \(task.startDate, formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Priority: \(task.priority.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(priorityColor(for: task.priority))
                Text("Duration: \(task.durationInDays) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if isEditingStatus {
                    Picker("Status", selection: Binding(
                        get: { task.status },
                        set: { newStatus in
                            updateStatus(newStatus)
                            isEditingStatus = false
                        }
                    )) {
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                } else {
                    Text("Status: \(task.status.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(statusColor(for: task.status))
                        .onTapGesture {
                            isEditingStatus = true
                        }
                }
            }
            Spacer()
            Button(action: toggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .contentShape(Rectangle())
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

    private func statusColor(for status: TaskStatus) -> Color {
        switch status {
        case .notStarted: return .gray
        case .inProgress: return .blue
        case .completed: return .green
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(
            task: Task(
                title: "Inspect foundation",
                isCompleted: false,
                durationInDays: 3,
                assignedTo: "John Doe",
                priority: .high,
                status: .inProgress,
                startDate: Date()
            ),
            toggleCompletion: {},
            updateStatus: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}