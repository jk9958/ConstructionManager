import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $themeManager.selectedTheme) {
                        ForEach(Theme.allCases) { theme in
                            Text(theme.rawValue.capitalized).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Theme Preview")) {
                    HStack(spacing: DS.m) {
                        Text("Current theme:")
                        Spacer()
                        Text(themeManager.selectedTheme.rawValue.capitalized)
                            .foregroundColor(Color.appAccent)
                            .font(DS.subtitle)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ThemedPreview(theme: .brand) {
            SettingsView()
        }
    }
}
