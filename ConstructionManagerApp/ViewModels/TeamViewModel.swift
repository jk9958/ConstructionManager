import Foundation

class TeamViewModel: ObservableObject {
    @Published var teams: [Team] = []
    @Published var errorMessage: String?

    func loadTeams() {
        teams = CoreDataManager.shared.fetchTeams()
    }

    func addTeam(_ team: Team) -> Bool {
        let success = CoreDataManager.shared.createTeam(from: team)
        if !success { errorMessage = "Failed to create team" }
        loadTeams()
        return success
    }

    func deleteTeam(_ team: Team) {
        // Implement delete if needed; for now not implemented in CoreDataManager
        loadTeams()
    }
}
