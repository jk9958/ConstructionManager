import SwiftUI

struct ThemePreviewView: View {
    let theme: Theme

    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            VStack(spacing: DS.l) {
                Text("Construction Manager Theme")
                    .font(DS.title)
                    .foregroundColor(.primary)
                    .padding(.top, DS.xl)

                VStack(alignment: .leading, spacing: DS.m) {
                    Text("Card Example")
                        .font(DS.subtitle)
                        .foregroundColor(theme.secondaryText)
                    RoundedRectangle(cornerRadius: DS.cornerRadius)
                        .fill(theme.card)
                        .frame(height: 96)
                        .overlay(
                            HStack {
                                VStack(alignment: .leading, spacing: DS.s) {
                                    Text("Task card")
                                        .font(DS.body)
                                        .foregroundColor(.primary)
                                    Text("On-site inspection and progress updates")
                                        .font(DS.caption)
                                        .foregroundColor(theme.secondaryText)
                                }
                                Spacer()
                                Circle()
                                    .fill(theme.accent)
                                    .frame(width: 36, height: 36)
                                    .shadow(radius: 4)
                            }
                            .padding(DS.m)
                        )
                }
                .padding(.horizontal, DS.l)

                VStack(spacing: DS.m) {
                    HStack(spacing: DS.m) {
                        Button("Primary") { }
                            .buttonStyle(PrimaryButtonStyle())
                        Button("Success") { }
                            .padding(.vertical, DS.m)
                            .padding(.horizontal, DS.l)
                            .background(theme.success)
                            .foregroundColor(.white)
                            .cornerRadius(DS.cornerRadius)
                        Button("Danger") { }
                            .padding(.vertical, DS.m)
                            .padding(.horizontal, DS.l)
                            .background(theme.danger)
                            .foregroundColor(.white)
                            .cornerRadius(DS.cornerRadius)
                    }
                    HStack(spacing: DS.m) {
                        Capsule()
                            .fill(theme.accent.opacity(0.15))
                            .frame(height: 56)
                            .overlay(Text("Status badge").font(DS.subtitle).foregroundColor(theme.accent))
                        Capsule()
                            .fill(theme.success.opacity(0.15))
                            .frame(height: 56)
                            .overlay(Text("Complete").font(DS.subtitle).foregroundColor(theme.success))
                        Capsule()
                            .fill(theme.danger.opacity(0.15))
                            .frame(height: 56)
                            .overlay(Text("Attention").font(DS.subtitle).foregroundColor(theme.danger))
                    }
                }
                .padding(.horizontal, DS.l)

                Spacer()
            }
        }
    }
}

struct ThemePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(Theme.allCases) { theme in
                ThemePreviewView(theme: theme)
                    .previewDisplayName(theme.rawValue.capitalized)
            }
        }
    }
}
