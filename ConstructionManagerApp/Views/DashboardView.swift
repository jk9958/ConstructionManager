import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to Construction Manager")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: ProjectListView()) {
                    Text("View Projects")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }

                NavigationLink(destination: TaskListView()) {
                    Text("View Tasks")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
