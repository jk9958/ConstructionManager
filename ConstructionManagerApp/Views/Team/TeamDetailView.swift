import SwiftUI

struct TeamDetailView: View {
    var team: Team

    var body: some View {
        VStack(alignment: .leading, spacing: DS.m) {
            Text(team.name ?? "Untitled Team")
                .font(DS.title)
                .fontWeight(.bold)
            if let created = team.createdAt {
                Text("Created: \(created.formatted())")
                    .font(DS.caption)
                    .foregroundColor(DS.dim(0.7))
            }
            if let members = team.members, !members.isEmpty {
                Text("Members:")
                    .font(DS.subtitle)
                    .fontWeight(.semibold)
                ForEach(members) { user in
                    Text(user.displayName ?? "Failed to get Display Name")
                        .font(DS.body)
                        .foregroundColor(.primary)
                }
            } else {
                Text("No members yet")
                    .foregroundColor(DS.dim(0.6))
            }
            Spacer()
        }
        .padding(DS.l)
        .background(Color.appCard)
        .cornerRadius(DS.cornerRadius)
        .padding(DS.m)
        .navigationTitle("Team")
    }
}
