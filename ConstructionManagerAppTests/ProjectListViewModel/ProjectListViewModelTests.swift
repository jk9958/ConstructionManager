import XCTest
@testable import ConstructionManagerApp

final class ProjectListViewModelTests: XCTestCase {

    func testProjectListViewModel_addProjectPersistsToCoreData() {
        let viewModel = ProjectListViewModel()
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate)!

        viewModel.addProject(name: "Unit Test Project", description: "Test Description", startDate: startDate, endDate: endDate, budget: 1200)

        guard let createdProject = viewModel.projects.last else {
            return XCTFail("Expected new project to be added")
        }

        let fetchedProject = CoreDataManager.shared.fetchProjectModel(createdProject.id)
        XCTAssertNotNil(fetchedProject, "Created project should be retrievable from Core Data")
        XCTAssertEqual(fetchedProject?.name, createdProject.name)
        XCTAssertEqual(fetchedProject?.budget, createdProject.budget)

        CoreDataManager.shared.deleteProject(createdProject)
    }
}
