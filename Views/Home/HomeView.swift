import SwiftUI

struct HomeView: View {
    @StateObject private var taskViewModel = TaskViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(taskViewModel.tasks.filter { !$0.isCompleted }) { task in
                    TaskRowView(task: task, toggleCompletion: {
                        if let index = taskViewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                            taskViewModel.toggleTaskCompletion(at: index)
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