import SwiftUI

struct HomeView: View {
    @StateObject private var taskViewModel = TaskViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredTasks) { task in
                    TaskRowView(
                        task: task,
                        toggleCompletion: {
                            if taskViewModel.tasks.contains(where: { $0.id == task.id }) {
                                taskViewModel.toggleTaskCompletion(task: task.id)
                            }
                        },
                        updateStatus: { status in
                            if taskViewModel.tasks.contains(where: { $0.id == task.id }) {
                                taskViewModel.updateStatus(ofTask: task.id, status: status)
                            }
                        }
                    )
                    .listRowBackground(Color.appBackground)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Ongoing Tasks")
            .onAppear {
                taskViewModel.refreshTasks()
            }
        }
    }

    /// Filters tasks that are either due (deadline is today or earlier) or in progress.
    private var filteredTasks: [Task] {
        taskViewModel.tasks.filter { task in
            let isDue = task.deadline != nil && Calendar.current.isDateInToday(task.deadline!) || (task.deadline ?? Date()) < Date()
            let isInProgress = task.status == .inProgress
            return isDue || isInProgress
        }
    }
}

#Preview {
    ThemedPreview(theme: .brand) {
        HomeView()
    }
}
