import SwiftUI

struct TaskDetailView: View {
    var body: some View {
        Text("Task Details")
            .font(.largeTitle)
            .padding()
            .navigationTitle("Task Details")
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView()
    }
}