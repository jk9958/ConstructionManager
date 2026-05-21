import SwiftUI

struct TeamMember: Identifiable {
    var id = UUID()
    var name: String
    var role: String
}

struct TeamView: View {
    @State private var teamMembers: [TeamMember] = [
        TeamMember(name: "John Doe", role: "Site Manager"),
        TeamMember(name: "Jane Smith", role: "Engineer")
    ]

    var body: some View {
        List(teamMembers) { member in
            VStack(alignment: .leading) {
                Text(member.name)
                    .font(.headline)
                Text(member.role)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Team Members")
    }
}

#Preview {
    TeamView()
}