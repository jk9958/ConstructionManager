import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var themeManager: ThemeManager

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

            TeamListView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Team")
                }

            DocumentListView()
                .tabItem {
                    Image(systemName: "doc.fill")
                    Text("Documents")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(ThemeManager())
}