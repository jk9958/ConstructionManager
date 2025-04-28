import SwiftUI

struct ProjectRowView: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name)
                .font(.headline)
            Text(project.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            ProgressView(value: project.progress)
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.top, 4)
        }
        .padding(.vertical, 8)
    }
}

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