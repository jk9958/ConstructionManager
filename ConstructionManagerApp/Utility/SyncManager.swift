import Foundation

final class SyncManager {
    static let shared = SyncManager()

    private init() {}

    struct ExportPayload: Codable {
        var projects: [Project]
        var tasks: [Task]
        var expenses: [Expense]
        var documents: [Document]
        var teams: [Team]
    }

    @discardableResult
    func exportAllData() -> Result<URL, Error> {
        let projects = CoreDataManager.shared.fetchProjects()
        let tasks = CoreDataManager.shared.fetchTasks()
        let expenses: [Expense] = projects.flatMap { $0.expenses ?? [] } // or fetchExpenses
        let documents: [Document] = projects.flatMap { $0.documents ?? [] }
        let teams = CoreDataManager.shared.fetchTeams()

        let payload = ExportPayload(projects: projects, tasks: tasks, expenses: expenses, documents: documents, teams: teams)

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(payload)

            let fm = FileManager.default
            let docs = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let filename = "construction-manager-export-\(ISO8601DateFormatter().string(from: Date())).json"
            let fileURL = docs.appendingPathComponent(filename)
            try data.write(to: fileURL, options: .atomic)
            return .success(fileURL)
        } catch {
            return .failure(error)
        }
    }

    func importFromURL(_ url: URL) -> Result<Bool, Error> {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let payload = try decoder.decode(ExportPayload.self, from: data)

            // Basic import: create projects and their related objects. This may duplicate data.
            for project in payload.projects {
                CoreDataManager.shared.createProject(from: project)
            }
            for task in payload.tasks {
                if let pid = task.projectId {
                    CoreDataManager.shared.createTask(from: task, forProjectId: pid)
                } else {
                    // create without project
                    _ = CoreDataManager.shared.createTask(from: task, forProjectId: UUID())
                }
            }
            for expense in payload.expenses {
                // attaching expenses to projects is handled in createProject when present
                _ = CoreDataManager.shared.createExpense(from: expense, for: nil)
            }
//            for document in payload.documents {
//                _ = CoreDataManager.shared.createDocument(from: document, for: nil)
//            }
            for team in payload.teams {
                _ = CoreDataManager.shared.createTeam(from: team)
            }

            return .success(true)
        } catch {
            return .failure(error)
        }
    }
}
