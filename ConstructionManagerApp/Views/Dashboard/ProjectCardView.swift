import SwiftUI
import Foundation

struct ProjectCardView: View {
    var project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name ?? "N/A")
                .font(.headline)
                .padding(.bottom, 2)
            Text(project.projectDescription ?? "N/A")
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text("Budget: $\(project.budget, specifier: "%.2f")")
                    .font(.caption)
                Spacer()
                Text("Ends: \(project.expectedEndDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
                    .font(.caption)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

struct ProjectCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCardView(
            project: Project(
                id: UUID(),
                name: "Build a House",
                projectDescription: "Residential construction",
                priority: "High",
                status: "In Progress",
                budget: 50000,
                location: "New York",
                startDate: Date(),
                expectedEndDate: Date().addingTimeInterval(86400 * 30),
                createdAt: Date(),
                updatedAt: nil,
                documents: [],
                expenses: [],
                tasks: [],
                team: nil
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
