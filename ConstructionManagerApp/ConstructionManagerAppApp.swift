import SwiftUI

@main
struct ConstructionManagerApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(themeManager)
        }
    }
}
