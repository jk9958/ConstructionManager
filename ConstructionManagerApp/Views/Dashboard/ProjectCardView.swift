import SwiftUI
import Foundation

struct ProjectCardView: View {
    var project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name)
                .font(.headline)
                .padding(.bottom, 2)
            Text(project.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text("Budget: $\(project.budget, specifier: "%.2f")")
                    .font(.caption)
                Spacer()
                Text("Ends: \(project.endDate, style: .date)")
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
                name: "Build a House",
                description: "Residential construction",
                startDate: Date(),
                endDate: Date().addingTimeInterval(86400 * 30),
                budget: 50000,
                tasks: [],
                expenses: []
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
