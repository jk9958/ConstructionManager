import Foundation
import os

/// Centralized `os.Logger` instances. Prefer these over `print()` so log
/// output is structured, filterable in Console.app, and stripped in release
/// builds where appropriate.
extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "ConstructionManagerApp"

    /// Core Data persistence (saves, fetches, migrations).
    static let coreData = Logger(subsystem: subsystem, category: "CoreData")

    /// Offline queue and remote synchronization.
    static let sync = Logger(subsystem: subsystem, category: "Sync")
}
