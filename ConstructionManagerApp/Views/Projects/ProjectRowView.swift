import SwiftUI

struct ProjectRowView: View {
    var project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name)
                .font(.headline)
            Text("Budget: $\(project.budget, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.blue)
            Text("Ends: \(project.endDate, style: .date)")
                .font(.caption)
                .foregroundColor(.gray)
            ProgressView(value: project.progress)
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.top, 4)
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
