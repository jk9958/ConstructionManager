
import SwiftUI

struct HomeView: View {
    @StateObject private var taskViewModel = TaskViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(taskViewModel.tasks.filter { !$0.isCompleted }) { task in
                    TaskRowView(task: task, toggleCompletion: {
                        if taskViewModel.tasks.contains(where: { $0.id == task.id }) {
                            taskViewModel.toggleTaskCompletion(task: task.id)
                        }
                    }, updateStatus: { status in
                        if taskViewModel.tasks.contains(where: { $0.id == task.id }) {
                            taskViewModel.updateStatus(ofTask: task.id, status: status)
                        }
                    })
                }
            }
            .navigationTitle("Latest Tasks")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
