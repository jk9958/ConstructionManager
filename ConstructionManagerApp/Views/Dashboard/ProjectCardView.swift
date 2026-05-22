import SwiftUI
import Foundation

struct ProjectCardView: View {
    var project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: DS.s) {
            Text(project.name ?? "N/A")
                .font(DS.title)
                .foregroundColor(.primary)
            Text(project.projectDescription ?? "N/A")
                .font(DS.subtitle)
                .foregroundColor(DS.dim(0.6))
            HStack {
                Text("Budget: $\(project.budget, specifier: "%.2f")")
                    .font(DS.caption)
                    .foregroundColor(DS.dim(0.7))
                Spacer()
                Text("Ends: \(project.expectedEndDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
                    .font(DS.caption)
                    .foregroundColor(DS.dim(0.7))
            }
        }
        .padding(DS.m)
        .background(Color.appCard)
        .cornerRadius(DS.cornerRadius)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    ThemedPreview(theme: .brand) {
        ProjectCardView(
            project: Project(
                id: UUID(),
                name: "Build a House",
                projectDescription: "Residential construction",
                priority: .high,
                status: .inProgress,
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
