import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "ConstructionManager")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                #if DEBUG
                fatalError("Failed to load Core Data stack: \(error)")
                #else
                let description = NSPersistentStoreDescription()
                description.type = NSInMemoryStoreType
                self.persistentContainer.persistentStoreDescriptions = [description]
                self.persistentContainer.loadPersistentStores { _, _ in }
                #endif
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    @discardableResult
    func saveContext() -> Bool {
        guard context.hasChanges else { return true }
        var success = true
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
                success = false
            }
        }
        return success
    }
}

extension CoreDataManager {
    // MARK: - TaskEntity CRUD
    private func fetchOrCreateTaskEntity(id: UUID) -> TaskEntity {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let existing = try? context.fetch(fetchRequest).first {
            return existing
        }
        return TaskEntity(context: context)
    }

    private func fetchOrCreateExpenseEntity(id: UUID) -> ExpenseEntity {
        let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let existing = try? context.fetch(fetchRequest).first {
            return existing
        }
        return ExpenseEntity(context: context)
    }

    private func fetchOrCreateDocumentEntity(id: UUID) -> DocumentEntity {
        let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let existing = try? context.fetch(fetchRequest).first {
            return existing
        }
        return DocumentEntity(context: context)
    }

    @discardableResult
    func createTask(from task: Task, forProjectId id: UUID) -> Bool {
        let taskEntity = fetchOrCreateTaskEntity(id: task.id)
        taskEntity.id = task.id
        // Provide safe defaults for non-optional model attributes
        taskEntity.title = task.title.isEmpty ? "Untitled" : task.title
        taskEntity.taskDescription = task.taskDescription ?? "No description provided"
        taskEntity.isCompleted = task.isCompleted
        taskEntity.priority = task.priority.rawValue
        // dueDate and startDate are required in the model; fall back to sensible defaults
        taskEntity.startDate = task.startDate ?? Date()
        taskEntity.dueDate = task.deadline ?? task.startDate ?? Date()
        taskEntity.status = task.status.rawValue
        taskEntity.createdAt = task.createdAt ?? Date()
        taskEntity.updatedAt = task.updatedAt ?? Date()
        taskEntity.completionPercentage = task.completionPercentage

        // Assign the task to a project
        taskEntity.project = fetchProject(id)

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

        let success = saveContext()
        if !success {
            // queue offline operation for remote sync
            if let payload = try? JSONEncoder().encode(task) {
                let op = OfflineOperation(type: .create, entityName: "Task", payload: payload)
                OfflineOperationQueue.shared.enqueue(op)
            }
        }
        return success
    }

    func fetchTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let taskEntities = try context.fetch(fetchRequest)
            return taskEntities.map { taskEntity in
                let durationInDays = calculateDurationInDays(startDate: taskEntity.startDate, dueDate: taskEntity.dueDate)
                return Task(
                    id: taskEntity.id ?? UUID(),
                    projectId: taskEntity.project?.id,
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

    func fetchTasks(forProjectId id: UUID) -> [Task] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        guard let projectEntity = fetchProject(id) else { return [] }
        // Filter tasks by project if provided
        fetchRequest.predicate = NSPredicate(format: "project == %@", projectEntity)

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
//    func createDocument(from document: Document, for project: ProjectEntity?) {
//        let documentEntity = DocumentEntity(context: context)
//        documentEntity.id = document.id
//        documentEntity.name = document.name
//        documentEntity.documentDescription = document.documentDescription
//        documentEntity.documentType = document.documentType
//        documentEntity.data = document.data
//        documentEntity.updatedAt = document.updatedAt
//        documentEntity.project = project
//
//        saveContext()
//    }

    @discardableResult
    func createDocument(from document: Document, for project: ProjectEntity?) -> Bool {
        let documentEntity = DocumentEntity(context: context)
        documentEntity.id = document.id
        documentEntity.name = document.name
        documentEntity.documentDescription = document.documentDescription
        documentEntity.documentType = document.documentType
        documentEntity.data = document.data
        documentEntity.updatedAt = document.updatedAt
        documentEntity.project = project

        return saveContext()
    }

    // MARK: - TeamEntity CRUD
    private func fetchOrCreateTeamEntity(id: UUID) -> TeamEntity {
        let fetchRequest: NSFetchRequest<TeamEntity> = TeamEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let existing = try? context.fetch(fetchRequest).first {
            return existing
        }
        return TeamEntity(context: context)
    }

    func createTeam(from team: Team) -> Bool {
        let teamEntity = fetchOrCreateTeamEntity(id: team.id)
        teamEntity.id = team.id
        teamEntity.name = team.name
        teamEntity.createdAt = team.createdAt
        teamEntity.createdBy = team.createdBy
        teamEntity.updatedAt = team.updatedAt

        // handle members relationship
        if let members = team.members {
            let userEntities = members.map { user -> UserEntity in
                let ue = UserEntity(context: context)
                ue.id = user.id
                ue.displayName = user.displayName
                ue.email = user.email
                ue.role = user.role
                return ue
            }
            teamEntity.members = NSSet(array: userEntities)
        }

        return saveContext()
    }

    func fetchTeams() -> [Team] {
        let fetchRequest: NSFetchRequest<TeamEntity> = TeamEntity.fetchRequest()
        do {
            let teamEntities = try context.fetch(fetchRequest)
            return teamEntities.map { teamEntity in
                Team(
                    id: teamEntity.id ?? UUID(),
                    name: teamEntity.name,
                    createdAt: teamEntity.createdAt,
                    createdBy: teamEntity.createdBy,
                    updatedAt: teamEntity.updatedAt,
                    members: fetchUsers(from: teamEntity.members),
                    projects: fetchProjects(from: teamEntity.projects)
                )
            }
        } catch {
            print("Failed to fetch teams: \(error)")
            return []
        }
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
        let expenseEntity = fetchOrCreateExpenseEntity(id: expense.id)
        expenseEntity.id = expense.id
        expenseEntity.title = expense.title
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
    private func fetchOrCreateProjectEntity(id: UUID) -> ProjectEntity {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let existing = try? context.fetch(fetchRequest).first {
            return existing
        }
        return ProjectEntity(context: context)
    }

    func createProject(from project: Project) {
        let projectEntity = fetchOrCreateProjectEntity(id: project.id)
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
                let documentEntity = fetchOrCreateDocumentEntity(id: document.id)
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
                let expenseEntity = fetchOrCreateExpenseEntity(id: expense.id)
                expenseEntity.id = expense.id
                expenseEntity.title = expense.title
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
                let taskEntity = fetchOrCreateTaskEntity(id: task.id)
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

    func fetchProject(_ id: UUID) -> ProjectEntity? {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let projectEntity = try context.fetch(fetchRequest)
            return projectEntity.first
        } catch {
            print("Failed to delete project: \(error)")
            return nil
        }
    }

    func fetchProjectModel(_ id: UUID) -> Project? {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            guard let projectEntity = try context.fetch(fetchRequest).first else { return nil }
            return Project(
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
        } catch {
            print("Failed to delete project: \(error)")
            return nil
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

extension CoreDataManager {
    func updateProject(from project: Project) {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", project.id as CVarArg)
        do {
            guard let projectEntity = try context.fetch(fetchRequest).first else { return }
            projectEntity.name = project.name
            projectEntity.projectDescription = project.projectDescription
            projectEntity.priority = project.priority
            projectEntity.status = project.status
            projectEntity.budget = project.budget
            projectEntity.location = project.location
            projectEntity.startDate = project.startDate
            projectEntity.expectedEndDate = project.expectedEndDate
            projectEntity.updatedAt = Date()
            saveContext()
        } catch {
            print("Failed to update project: \(error)")
        }
    }

    @discardableResult
    func updateTask(_ task: Task) -> Bool {
        // Use fetchOrCreate to ensure the entity exists and relationships are updated
        let taskEntity = fetchOrCreateTaskEntity(id: task.id)

        taskEntity.id = task.id
        taskEntity.title = task.title
        taskEntity.taskDescription = task.taskDescription
        taskEntity.isCompleted = task.isCompleted
        taskEntity.priority = task.priority.rawValue
        taskEntity.dueDate = task.deadline
        taskEntity.startDate = task.startDate
        taskEntity.status = task.status.rawValue
        taskEntity.completionPercentage = task.completionPercentage
        // Preserve createdAt if already set, otherwise set from model
        if taskEntity.createdAt == nil {
            taskEntity.createdAt = task.createdAt
        }
        taskEntity.updatedAt = task.updatedAt ?? Date()

        // Assign or update project relationship
        if let projectId = task.projectId, let projectEntity = fetchProject(projectId) {
            taskEntity.project = projectEntity
        }

        // Update assignedTo relationship
        if let assignedTo = task.assignedTo {
            let userEntities = fetchUsers(by: assignedTo)
            taskEntity.assignedTo = NSSet(array: userEntities)
        } else {
            taskEntity.assignedTo = nil
        }

        // Update dependencies relationship
        if let dependencies = task.dependencies {
            let dependencyEntities = fetchTasks(by: dependencies)
            taskEntity.dependencies = NSSet(array: dependencyEntities)
        } else {
            taskEntity.dependencies = nil
        }

        // Persist changes
        let success = saveContext()
        if !success {
            print("Failed to persist updated task with id: \(task.id)")
            if let payload = try? JSONEncoder().encode(task) {
                let op = OfflineOperation(type: .update, entityName: "Task", payload: payload)
                OfflineOperationQueue.shared.enqueue(op)
            }
        }
        return success
    }
}
