import SwiftUI

struct ProjectRowView: View {
    var project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name ?? "")
                .font(.headline)
            Text("Budget: $\(project.budget, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.blue)
            Text("End Date: \(project.endDate?.formatted() ?? "N/A")")
                .font(.caption)
                .foregroundColor(.gray)
            Text("Progress: N/A")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

import SwiftUI

struct ProjectRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectRowView(
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
                updatedAt: Date(),
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
