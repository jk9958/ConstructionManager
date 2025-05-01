import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "ConstructionManagerApp") // Match your .xcdatamodeld file name
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}

extension CoreDataManager {
    // MARK: - TaskEntity CRUD
    func createTask(from task: Task, for project: ProjectEntity?) {
        let taskEntity = TaskEntity(context: context)
        taskEntity.id = task.id
        taskEntity.title = task.title
        taskEntity.taskDescription = task.taskDescription
        taskEntity.isCompleted = task.isCompleted
        taskEntity.priority = task.priority.rawValue
        taskEntity.dueDate = task.deadline
        taskEntity.startDate = task.startDate
        taskEntity.status = task.status.rawValue
        taskEntity.createdAt = task.createdAt
        taskEntity.updatedAt = task.updatedAt ?? Date()
        taskEntity.completionPercentage = task.completionPercentage

        // Assign the task to a project
        taskEntity.project = project

        // Handle `assignedTo` relationship
        if let assignedTo = task.assignedTo {
            let userEntities = fetchUsers(by: assignedTo)
            taskEntity.assignedTo = NSSet(array: userEntities)
        }

        // Handle `dependencies` relationship
        if let dependencies = task.dependencies {
            let dependencyEntities = fetchTasks(by: dependencies)
            taskEntity.dependencies = NSSet(array: dependencyEntities)
        }

        saveContext()
    }

    func fetchTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let taskEntities = try context.fetch(fetchRequest)
            return taskEntities.map { taskEntity in
                let durationInDays = calculateDurationInDays(startDate: taskEntity.startDate, dueDate: taskEntity.dueDate)
                return Task(
                    id: taskEntity.id ?? UUID(),
                    title: taskEntity.title ?? "Untitled",
                    taskDescription: taskEntity.taskDescription,
                    isCompleted: taskEntity.isCompleted,
                    durationInDays: durationInDays,
                    assignedTo: fetchAssignedToUUIDs(from: taskEntity.assignedTo),
                    priority: TaskPriority(rawValue: taskEntity.priority ?? "Medium") ?? .medium,
                    deadline: taskEntity.dueDate,
                    status: TaskStatus(rawValue: taskEntity.status ?? "Not Started") ?? .notStarted,
                    startDate: taskEntity.startDate ?? Date(),
                    createdAt: taskEntity.createdAt ?? Date(),
                    updatedAt: taskEntity.updatedAt
                )
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    func fetchTasks(for project: ProjectEntity?) -> [Task] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

        // Filter tasks by project if provided
        if let project = project {
            fetchRequest.predicate = NSPredicate(format: "project == %@", project)
        }

        do {
            let taskEntities = try context.fetch(fetchRequest)
            return taskEntities.map { taskEntity in
                let durationInDays = calculateDurationInDays(startDate: taskEntity.startDate, dueDate: taskEntity.dueDate)
                return Task(
                    id: taskEntity.id ?? UUID(),
                    title: taskEntity.title ?? "Untitled",
                    taskDescription: taskEntity.taskDescription,
                    isCompleted: taskEntity.isCompleted,
                    durationInDays: durationInDays,
                    assignedTo: fetchAssignedToUUIDs(from: taskEntity.assignedTo),
                    priority: TaskPriority(rawValue: taskEntity.priority ?? "Medium") ?? .medium,
                    deadline: taskEntity.dueDate,
                    status: TaskStatus(rawValue: taskEntity.status ?? "Not Started") ?? .notStarted,
                    startDate: taskEntity.startDate ?? Date(),
                    createdAt: taskEntity.createdAt ?? Date(),
                    updatedAt: taskEntity.updatedAt
                )
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    func deleteTask(_ task: Task) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        do {
            let taskEntities = try context.fetch(fetchRequest)
            for taskEntity in taskEntities {
                context.delete(taskEntity)
            }
            saveContext()
        } catch {
            print("Failed to delete task: \(error)")
        }
    }

    // MARK: - DocumentEntity CRUD
    func createDocument(from document: Document, for project: ProjectEntity?) {
        let documentEntity = DocumentEntity(context: context)
        documentEntity.id = document.id
        documentEntity.name = document.name
        documentEntity.documentDescription = document.documentDescription
        documentEntity.documentType = document.documentType
        documentEntity.data = document.data
        documentEntity.updatedAt = document.updatedAt
        documentEntity.project = project

        saveContext()
    }

    func fetchDocuments(for project: ProjectEntity?) -> [Document] {
        let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()

        if let project = project {
            fetchRequest.predicate = NSPredicate(format: "project == %@", project)
        }

        do {
            let documentEntities = try context.fetch(fetchRequest)
            return documentEntities.map { documentEntity in
                Document(
                    id: documentEntity.id ?? UUID(),
                    name: documentEntity.name ?? "Untitled",
                    documentDescription: documentEntity.documentDescription,
                    documentType: documentEntity.documentType,
                    data: documentEntity.data,
                    updatedAt: documentEntity.updatedAt
                )
            }
        } catch {
            print("Failed to fetch documents: \(error)")
            return []
        }
    }

    func deleteDocument(_ document: Document) {
        let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", document.id as CVarArg)
        do {
            let documentEntities = try context.fetch(fetchRequest)
            for documentEntity in documentEntities {
                context.delete(documentEntity)
            }
            saveContext()
        } catch {
            print("Failed to delete document: \(error)")
        }
    }

    // MARK: - ExpenseEntity CRUD
    func createExpense(from expense: Expense, for project: ProjectEntity?) {
        let expenseEntity = ExpenseEntity(context: context)
        expenseEntity.id = expense.id
        expenseEntity.expenseDescription = expense.expenseDescription
        expenseEntity.amount = expense.amount
        expenseEntity.category = expense.category
        expenseEntity.date = expense.date
        expenseEntity.status = expense.status
        expenseEntity.submittedBy = expense.submittedBy
        expenseEntity.receiptURL = expense.receiptURL
        expenseEntity.createdAt = expense.createdAt
        expenseEntity.updatedAt = expense.updatedAt
        expenseEntity.project = project

        saveContext()
    }

    func fetchExpenses(for project: ProjectEntity?) -> [Expense] {
        let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()

        if let project = project {
            fetchRequest.predicate = NSPredicate(format: "project == %@", project)
        }

        do {
            let expenseEntities = try context.fetch(fetchRequest)
            return expenseEntities.map { expenseEntity in
                Expense(
                    id: expenseEntity.id ?? UUID(),
                    title: expenseEntity.title ?? "Untitled",
                    expenseDescription: expenseEntity.expenseDescription,
                    amount: expenseEntity.amount,
                    category: expenseEntity.category ?? "Uncategorized",
                    date: expenseEntity.date ?? Date(),
                    status: expenseEntity.status ?? "Pending",
                    submittedBy: expenseEntity.submittedBy ?? "Unknown",
                    receiptURL: expenseEntity.receiptURL,
                    createdAt: expenseEntity.createdAt ?? Date(),
                    updatedAt: expenseEntity.updatedAt
                )
            }
        } catch {
            print("Failed to fetch expenses: \(error)")
            return []
        }
    }

    func deleteExpense(_ expense: Expense) {
        let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", expense.id as CVarArg)
        do {
            let expenseEntities = try context.fetch(fetchRequest)
            for expenseEntity in expenseEntities {
                context.delete(expenseEntity)
            }
            saveContext()
        } catch {
            print("Failed to delete expense: \(error)")
        }
    }

    // MARK: - ProjectEntity CRUD
    func createProject(from project: Project) {
        let projectEntity = ProjectEntity(context: context)
        projectEntity.id = project.id
        projectEntity.name = project.name
        projectEntity.projectDescription = project.projectDescription
        projectEntity.priority = project.priority
        projectEntity.status = project.status
        projectEntity.budget = project.budget
        projectEntity.location = project.location
        projectEntity.startDate = project.startDate
        projectEntity.expectedEndDate = project.expectedEndDate
        projectEntity.createdAt = project.createdAt
        projectEntity.updatedAt = project.updatedAt

        // Handle `documents` relationship
        if let documents = project.documents {
            let documentEntities = documents.map { document in
                let documentEntity = DocumentEntity(context: context)
                documentEntity.id = document.id
                documentEntity.name = document.name
                documentEntity.documentDescription = document.documentDescription
                documentEntity.documentType = document.documentType
                documentEntity.data = document.data
                documentEntity.updatedAt = document.updatedAt
                return documentEntity
            }
            projectEntity.documents = NSSet(array: documentEntities)
        }

        // Handle `expenses` relationship
        if let expenses = project.expenses {
            let expenseEntities = expenses.map { expense in
                let expenseEntity = ExpenseEntity(context: context)
                expenseEntity.id = expense.id
                expenseEntity.expenseDescription = expense.expenseDescription
                expenseEntity.amount = expense.amount
                expenseEntity.category = expense.category
                expenseEntity.date = expense.date
                expenseEntity.status = expense.status
                expenseEntity.submittedBy = expense.submittedBy
                expenseEntity.receiptURL = expense.receiptURL
                expenseEntity.createdAt = expense.createdAt
                expenseEntity.updatedAt = expense.updatedAt
                return expenseEntity
            }
            projectEntity.expenses = NSSet(array: expenseEntities)
        }

        // Handle `tasks` relationship
        if let tasks = project.tasks {
            let taskEntities = tasks.map { task in
                let taskEntity = TaskEntity(context: context)
                taskEntity.id = task.id
                taskEntity.title = task.title
                taskEntity.taskDescription = task.taskDescription
                taskEntity.isCompleted = task.isCompleted
                taskEntity.priority = task.priority.rawValue
                taskEntity.dueDate = task.deadline
                taskEntity.startDate = task.startDate
                taskEntity.status = task.status.rawValue
                taskEntity.createdAt = task.createdAt
                taskEntity.updatedAt = task.updatedAt
                return taskEntity
            }
            projectEntity.tasks = NSSet(array: taskEntities)
        }

        saveContext()
    }

    func fetchProjects() -> [Project] {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        do {
            let projectEntities = try context.fetch(fetchRequest)
            return projectEntities.map { projectEntity in
                Project(
                    id: projectEntity.id ?? UUID(),
                    name: projectEntity.name,
                    projectDescription: projectEntity.projectDescription,
                    priority: projectEntity.priority,
                    status: projectEntity.status,
                    budget: projectEntity.budget,
                    location: projectEntity.location,
                    startDate: projectEntity.startDate,
                    expectedEndDate: projectEntity.expectedEndDate,
                    createdAt: projectEntity.createdAt,
                    updatedAt: projectEntity.updatedAt,
                    documents: fetchDocuments(from: projectEntity.documents),
                    expenses: fetchExpenses(from: projectEntity.expenses),
                    tasks: fetchTasks(from: projectEntity.tasks),
                    team: fetchTeam(from: projectEntity.team)
                )
            }
        } catch {
            print("Failed to fetch projects: \(error)")
            return []
        }
    }

    func deleteProject(_ project: Project) {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", project.id as CVarArg)
        do {
            let projectEntities = try context.fetch(fetchRequest)
            for projectEntity in projectEntities {
                context.delete(projectEntity)
            }
            saveContext()
        } catch {
            print("Failed to delete project: \(error)")
        }
    }

    // MARK: - Helper Methods
    private func fetchUsers(by uuids: [UUID]) -> [UserEntity] {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", uuids)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }

    private func fetchAssignedToUUIDs(from assignedTo: NSSet?) -> [UUID] {
        guard let userEntities = assignedTo as? Set<UserEntity> else { return [] }
        return userEntities.compactMap { $0.id }
    }

    private func fetchTasks(by uuids: [UUID]) -> [TaskEntity] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", uuids)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    private func calculateDurationInDays(startDate: Date?, dueDate: Date?) -> Int {
        guard let startDate = startDate, let dueDate = dueDate else { return 0 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: dueDate)
        return components.day ?? 0
    }

    private func fetchDocuments(from documents: NSSet?) -> [Document] {
        guard let documentEntities = documents as? Set<DocumentEntity> else { return [] }
        return documentEntities.map { documentEntity in
            Document(
                id: documentEntity.id ?? UUID(),
                name: documentEntity.name ?? "Untitled",
                documentDescription: documentEntity.documentDescription,
                documentType: documentEntity.documentType,
                data: documentEntity.data,
                updatedAt: documentEntity.updatedAt
            )
        }
    }

    private func fetchExpenses(from expenses: NSSet?) -> [Expense] {
        guard let expenseEntities = expenses as? Set<ExpenseEntity> else { return [] }
        return expenseEntities.map { expenseEntity in
            Expense(
                id: expenseEntity.id ?? UUID(),
                title: expenseEntity.title ?? "Untitled",
                expenseDescription: expenseEntity.expenseDescription,
                amount: expenseEntity.amount,
                category: expenseEntity.category ?? "Uncategorized",
                date: expenseEntity.date ?? Date(),
                status: expenseEntity.status ?? "Pending",
                submittedBy: expenseEntity.submittedBy ?? "Unknown",
                receiptURL: expenseEntity.receiptURL,
                createdAt: expenseEntity.createdAt ?? Date(),
                updatedAt: expenseEntity.updatedAt
            )
        }
    }

    private func fetchTasks(from tasks: NSSet?) -> [Task] {
        guard let taskEntities = tasks as? Set<TaskEntity> else { return [] }
        return taskEntities.map { taskEntity in
            Task(
                id: taskEntity.id ?? UUID(),
                title: taskEntity.title ?? "Untitled",
                taskDescription: taskEntity.taskDescription,
                isCompleted: taskEntity.isCompleted,
                durationInDays: calculateDurationInDays(startDate: taskEntity.startDate, dueDate: taskEntity.dueDate),
                assignedTo: fetchAssignedToUUIDs(from: taskEntity.assignedTo),
                priority: TaskPriority(rawValue: taskEntity.priority ?? "Medium") ?? .medium,
                deadline: taskEntity.dueDate,
                status: TaskStatus(rawValue: taskEntity.status ?? "Not Started") ?? .notStarted,
                startDate: taskEntity.startDate ?? Date(),
                createdAt: taskEntity.createdAt ?? Date(),
                updatedAt: taskEntity.updatedAt
            )
        }
    }

    private func fetchTeam(from team: TeamEntity?) -> Team? {
        guard let teamEntity = team else { return nil }
        return Team(
            id: teamEntity.id ?? UUID(),
            name: teamEntity.name ?? "Untitled",
            createdAt: teamEntity.createdAt ?? Date(),
            createdBy: teamEntity.createdBy ?? UUID(),
            updatedAt: teamEntity.updatedAt,
            members: fetchUsers(from: teamEntity.members),
            projects: fetchProjects(from: teamEntity.projects)
        )
    }

    private func fetchUsers(from members: NSSet?) -> [User] {
        guard let userEntities = members as? Set<UserEntity> else { return [] }
        return userEntities.map { userEntity in
            User(
                id: userEntity.id ?? UUID(),
                displayName: userEntity.displayName ?? "Unknown",
                email: userEntity.email ?? "Unknown",
                role: userEntity.role ?? "Unknown",
                department: userEntity.department,
                jobTitle: userEntity.jobTitle,
                phoneNumber: userEntity.phoneNumber,
                status: userEntity.status,
                preferences: userEntity.preferences,
                createdAt: userEntity.createdAt ?? Date(),
                updatedAt: userEntity.updatedAt,
                lastLoginAt: userEntity.lastLoginAt,
                assignedTasks: fetchTasks(from: userEntity.assignedTasks),
                teams: fetchTeams(from: userEntity.teams)
            )
        }
    }

    private func fetchProjects(from projects: NSSet?) -> [Project] {
        guard let projectEntities = projects as? Set<ProjectEntity> else { return [] }
        return projectEntities.map { projectEntity in
            Project(
                id: projectEntity.id ?? UUID(),
                name: projectEntity.name,
                projectDescription: projectEntity.projectDescription,
                priority: projectEntity.priority,
                status: projectEntity.status,
                budget: projectEntity.budget,
                location: projectEntity.location,
                startDate: projectEntity.startDate,
                expectedEndDate: projectEntity.expectedEndDate,
                createdAt: projectEntity.createdAt,
                updatedAt: projectEntity.updatedAt,
                documents: fetchDocuments(from: projectEntity.documents),
                expenses: fetchExpenses(from: projectEntity.expenses),
                tasks: fetchTasks(from: projectEntity.tasks),
                team: nil // Avoid circular reference
            )
        }
    }

    private func fetchTeams(from teams: NSSet?) -> [Team] {
        guard let teamEntities = teams as? Set<TeamEntity> else { return [] }
        return teamEntities.map { teamEntity in
            Team(
                id: teamEntity.id ?? UUID(),
                name: teamEntity.name ?? "Untitled",
                createdAt: teamEntity.createdAt ?? Date(),
                createdBy: teamEntity.createdBy ?? UUID(),
                updatedAt: teamEntity.updatedAt,
                members: fetchUsers(from: teamEntity.members),
                projects: fetchProjects(from: teamEntity.projects)
            )
        }
    }
}
