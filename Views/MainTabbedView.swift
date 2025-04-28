import SwiftUI

struct MainTabbedView: View {
    var body: some View {
        TabView {
            ProjectListView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Projects")
                }

            TaskListView()
                .tabItem {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Tasks")
                }

            ExpenseListView()
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("Expenses")
                }
        }
    }
}

struct MainTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbedView()
    }
}