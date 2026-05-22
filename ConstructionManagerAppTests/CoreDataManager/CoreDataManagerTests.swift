import XCTest
@testable import ConstructionManagerApp

final class CoreDataManagerTests: XCTestCase {

    func testCoreDataManager_createProjectAndFetchProjectModel() {
        let projectID = UUID()
        let sampleProject = Project(
            id: projectID,
            name: "Persistence Test Project",
            projectDescription: "Project used for persistence tests",
            priority: .high,
            status: .inProgress,
            budget: 3000,
            location: "Test Site",
            startDate: Date(),
            expectedEndDate: Calendar.current.date(byAdding: .day, value: 14, to: Date()),
            createdAt: Date(),
            updatedAt: Date(),
            documents: [],
            expenses: [
                Expense(
                    id: UUID(),
                    title: "Sheetrock",
                    expenseDescription: "Drywall purchase",
                    amount: 450.0,
                    category: "Materials",
                    date: Date(),
                    status: "Approved",
                    submittedBy: "Tester",
                    receiptURL: nil,
                    createdAt: Date(),
                    updatedAt: nil
                )
            ],
            tasks: [
                Task(
                    id: UUID(),
                    projectId: projectID,
                    title: "Measure foundation",
                    taskDescription: "Confirm site measurements",
                    isCompleted: false,
                    durationInDays: 2,
                    assignedTo: nil,
                    priority: .medium,
                    deadline: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
                    status: .notStarted,
                    startDate: Date(),
                    createdAt: Date(),
                    updatedAt: nil,
                    dependencies: nil
                )
            ],
            team: nil
        )

        CoreDataManager.shared.createProject(from: sampleProject)
        let fetchedProject = CoreDataManager.shared.fetchProjectModel(projectID)
        XCTAssertNotNil(fetchedProject)
        XCTAssertEqual(fetchedProject?.name, sampleProject.name)
        XCTAssertEqual(fetchedProject?.expenses?.count, 1)
        XCTAssertEqual(fetchedProject?.tasks?.count, 1)

        CoreDataManager.shared.deleteProject(sampleProject)
    }

    func testCoreDataManager_createTaskAndFetchTasksForProject() {
        let projectID = UUID()
        let sampleProject = Project(
            id: projectID,
            name: "Task Fetch Project",
            projectDescription: "Test project for task fetching",
            priority: .medium,
            status: .notStarted,
            budget: 1000,
            location: "Test Lab",
            startDate: Date(),
            expectedEndDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()),
            createdAt: Date(),
            updatedAt: Date(),
            documents: [],
            expenses: [],
            tasks: [],
            team: nil
        )
        CoreDataManager.shared.createProject(from: sampleProject)

        let taskID = UUID()
        let sampleTask = Task(
            id: taskID,
            projectId: projectID,
            title: "Inspect site",
            taskDescription: "Perform site inspection",
            isCompleted: false,
            durationInDays: 1,
            assignedTo: nil,
            priority: .high,
            deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            status: .notStarted,
            startDate: Date(),
            createdAt: Date(),
            updatedAt: nil,
            dependencies: nil
        )

        let created = CoreDataManager.shared.createTask(from: sampleTask, forProjectId: projectID)
        XCTAssertTrue(created)

        let fetchedTasks = CoreDataManager.shared.fetchTasks(forProjectId: projectID)
        XCTAssertEqual(fetchedTasks.count, 1)
        XCTAssertEqual(fetchedTasks.first?.title, sampleTask.title)

        CoreDataManager.shared.deleteTask(sampleTask)
        CoreDataManager.shared.deleteProject(sampleProject)
    }
}
