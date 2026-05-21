import Foundation
import os

final class OfflineOperationQueue {
    static let shared = OfflineOperationQueue()

    private let queueFileURL: URL
    private var operations: [OfflineOperation] = []
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let processingQueue = DispatchQueue(label: "OfflineOperationQueue.processing")

    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        let fm = FileManager.default
        // Fall back to the temporary directory if the documents directory is
        // unavailable, so construction never crashes the app at launch.
        let docs = (try? fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true))
            ?? fm.temporaryDirectory
        queueFileURL = docs.appendingPathComponent("offline-operations.json")
        load()
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: queueFileURL.path) else { return }
        do {
            let data = try Data(contentsOf: queueFileURL)
            operations = try decoder.decode([OfflineOperation].self, from: data)
        } catch {
            Logger.sync.error("Failed to load offline operations: \(error.localizedDescription, privacy: .public)")
            operations = []
        }
    }

    private func persist() {
        do {
            let data = try encoder.encode(operations)
            try data.write(to: queueFileURL, options: .atomic)
        } catch {
            Logger.sync.error("Failed to persist offline operations: \(error.localizedDescription, privacy: .public)")
        }
    }

    func enqueue(_ op: OfflineOperation) {
        processingQueue.sync {
            operations.append(op)
            persist()
            processQueueIfNeeded()
        }
    }

    func processQueueIfNeeded() {
        processingQueue.async { [weak self] in
            guard let self = self else { return }
            while !self.operations.isEmpty {
                let op = self.operations.first!
                let success = self.performRemoteOperation(op)
                if success {
                    self.operations.removeFirst()
                    self.persist()
                } else {
                    // stop processing on first failure to retry later
                    break
                }
            }
        }
    }

    // Placeholder remote sender; integrate with your API client.
    private func performRemoteOperation(_ op: OfflineOperation) -> Bool {
        // Simulate network call or hand off to an APIClient
        // For now, return true to indicate success
        Logger.sync.debug("Performing remote op: \(op.type.rawValue, privacy: .public) \(op.entityName, privacy: .public) id=\(op.id.uuidString, privacy: .public)")
        return true
    }

    func flush() {
        processQueueIfNeeded()
    }
}
