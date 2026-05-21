import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case brand
    case industrial
    case neutral

    var id: String { rawValue }

    var background: Color {
        switch self {
        case .brand: return Color("BrandBackground")
        case .industrial: return Color(red: 0.09, green: 0.10, blue: 0.14)
        case .neutral: return Color(UIColor.systemBackground)
        }
    }

    var card: Color {
        switch self {
        case .brand: return Color("BrandCard")
        case .industrial: return Color(red: 0.12, green: 0.14, blue: 0.19)
        case .neutral: return Color(UIColor.secondarySystemBackground)
        }
    }

    var accent: Color {
        switch self {
        case .brand: return Color("BrandAccent")
        case .industrial: return Color(red: 0.00, green: 0.60, blue: 0.54)
        case .neutral: return Color.blue
        }
    }

    var success: Color {
        switch self {
        case .brand: return Color("BrandSuccess")
        case .industrial: return Color.green
        case .neutral: return Color.green
        }
    }

    var danger: Color {
        switch self {
        case .brand: return Color("BrandDanger")
        case .industrial: return Color(red: 0.93, green: 0.25, blue: 0.22)
        case .neutral: return Color.red
        }
    }

    var secondaryText: Color {
        switch self {
        case .brand, .neutral: return Color.primary.opacity(0.7)
        case .industrial: return Color.white.opacity(0.75)
        }
    }
}

// Global design tokens for colors, spacing, and fonts
enum DS {
    static var theme: Theme = .brand

    // Spacing
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 20
    static let xl: CGFloat = 28

    // Radii
    static let cornerRadius: CGFloat = 12

    // Typography
    static var title: Font { .system(.headline, weight: .semibold) }
    static var subtitle: Font { .system(.subheadline, weight: .regular) }
    static var body: Font { .system(.body, weight: .regular) }
    static var caption: Font { .system(.caption, weight: .regular) }

    // Small helpers
    static func dim(_ amount: Double = 0.6) -> Color {
        Color.primary.opacity(amount)
    }
}

extension Color {
    static var appBackground: Color { DS.theme.background }
    static var appCard: Color { DS.theme.card }
    static var appAccent: Color { DS.theme.accent }
    static var appSuccess: Color { DS.theme.success }
    static var appDanger: Color { DS.theme.danger }
}

struct ThemedPreview<Content: View>: View {
    let content: Content

    init(theme: Theme, @ViewBuilder content: () -> Content) {
        DS.theme = theme
        self.content = content()
    }

    var body: some View {
        content
    }
}

class ThemeManager: ObservableObject {
    private static let storageKey = "selectedTheme"

    @Published var selectedTheme: Theme = .brand {
        didSet {
            DS.theme = selectedTheme
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: Self.storageKey)
        }
    }

    init() {
        if let storedValue = UserDefaults.standard.string(forKey: Self.storageKey),
           let theme = Theme(rawValue: storedValue) {
            selectedTheme = theme
        } else {
            selectedTheme = .brand
        }
        DS.theme = selectedTheme
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, DS.m)
            .padding(.horizontal, DS.l)
            .background(Color.appAccent.opacity(configuration.isPressed ? 0.8 : 1.0))
            .foregroundColor(.white)
            .cornerRadius(DS.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
