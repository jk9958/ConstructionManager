//
//  ConstructionManagerAppTests.swift
//  ConstructionManagerAppTests
//
//  Created by DakshinAJK on 24/04/2025.
//

import XCTest
@testable import ConstructionManagerApp

final class ConstructionManagerAppTests: XCTestCase {

    func testExpenseViewModel_loadsAndModifiesExpenses() {
        let viewModel = ExpenseViewModel()
        XCTAssertEqual(viewModel.expenses.count, 2, "ExpenseViewModel should start with two sample expenses")

        let newExpense = Expense(
            id: UUID(),
            title: "Test Materials",
            expenseDescription: "Test expense description",
            amount: 42.50,
            category: "Materials",
            date: Date(),
            status: "Pending",
            submittedBy: "Test User",
            receiptURL: nil,
            createdAt: Date(),
            updatedAt: nil
        )

        viewModel.addExpense(newExpense)
        XCTAssertEqual(viewModel.expenses.count, 3)
        XCTAssertEqual(viewModel.expenses.last?.id, newExpense.id)

        var updatedExpense = newExpense
        updatedExpense.amount = 55.75
        viewModel.updateExpense(updatedExpense)
        XCTAssertEqual(viewModel.expenses.last?.amount, 55.75)

        viewModel.removeExpense(at: 0)
        XCTAssertEqual(viewModel.expenses.count, 2)
    }

    func testProjectListViewModel_addProjectPersistsToCoreData() {
        let viewModel = ProjectListViewModel()
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate)!

        viewModel.addProject(name: "Unit Test Project", description: "Test Description", startDate: startDate, endDate: endDate, budget: 1200)

        guard let createdProject = viewModel.projects.last else {
            XCTFail("Expected new project to be added")
            return
        }

        let fetchedProject = CoreDataManager.shared.fetchProjectModel(createdProject.id)
        XCTAssertNotNil(fetchedProject, "Created project should be retrievable from Core Data")
        XCTAssertEqual(fetchedProject?.name, createdProject.name)
        XCTAssertEqual(fetchedProject?.budget, createdProject.budget)

        CoreDataManager.shared.deleteProject(createdProject)
    }

    func testCoreDataManager_createProjectAndFetchProjectModel() {
        let projectID = UUID()
        let sampleProject = Project(
            id: projectID,
            name: "Persistence Test Project",
            projectDescription: "Project used for persistence tests",
            priority: "High",
            status: "In Progress",
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
            priority: "Medium",
            status: "Not Started",
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
