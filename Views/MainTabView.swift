import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            ProjectListView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Projects")
                }

            TeamView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Team")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}