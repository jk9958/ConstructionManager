import Foundation

class ProjectViewModel: ObservableObject {
    @Published var projects: [Project] = []

    init() {
        // Initialize with a sample project
        let sampleProject = Project(
            name: "Sample Project",
            description: "Sample project description",
            startDate: Date(),
            endDate: Date(),
            budget: 10988.99,
            tasks: [
                Task(
                    title: "Task",
                    isCompleted: false,
                    durationInDays: 24,
                    priority: .medium
                )
            ],
            expenses: [
                Expense(
                    description: "Expense",
                    amount: 123.3,
                    date: Date()
                )
            ]
        )
        self.projects = [sampleProject]
    }
}