import Foundation

class DocumentViewModel: ObservableObject {
    @Published var documents: [Document] = []
    @Published var errorMessage: String?

    func loadDocuments(forProjectId projectId: UUID? = nil) {
        if let pid = projectId, let projectEntity = CoreDataManager.shared.fetchProject(pid) {
            documents = CoreDataManager.shared.fetchDocuments(for: projectEntity)
        } else {
            documents = CoreDataManager.shared.fetchDocuments(for: nil)
        }
    }

    func addDocument(_ document: Document, forProjectId projectId: UUID? = nil) -> Bool {
        let projectEntity: ProjectEntity? = {
            if let pid = projectId { return CoreDataManager.shared.fetchProject(pid) }
            return nil
        }()
        let success = CoreDataManager.shared.createDocument(from: document, for: projectEntity)
        if !success { errorMessage = "Failed to create document" }
        loadDocuments(forProjectId: projectId)
        return success
    }

    func deleteDocument(_ document: Document) {
        CoreDataManager.shared.deleteDocument(document)
        loadDocuments()
    }
}
