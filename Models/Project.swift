import Foundation
import SwiftUI

struct Project: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String?
    var projectDescription: String?
    var priority: String?
    var status: String?
    var budget: Double
    var location: String?
    var startDate: Date?
    var expectedEndDate: Date? // Core Data property
    var createdAt: Date?
    var updatedAt: Date?
    var documents: [Document]?
    var expenses: [Expense]?
    var tasks: [Task]?
    var team: Team?

    // Computed property for endDate
    var endDate: Date? {
        return expectedEndDate
    }

    // Computed property for progress
    var progress: Double {
        guard let tasks = tasks, !tasks.isEmpty else { return 0.0 }
        let completedTasks = tasks.filter { $0.isCompleted }.count
        return Double(completedTasks) / Double(tasks.count)
    }

    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
}

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
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}