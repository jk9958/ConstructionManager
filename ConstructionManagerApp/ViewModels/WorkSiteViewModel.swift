import Foundation
import Combine

class WorkSiteViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var progress: Double = 0.0
    @Published var teamMembers: [TeamMember] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadInitialData()
    }
    
    func loadInitialData() {
        // Sample data for tasks
        tasks = [
            Task(title: "Inspect foundation", isCompleted: false, durationInDays: 100, priority: .high, startDate: Date(), createdAt: Date()),
            Task(title: "Order materials", isCompleted: true, durationInDays: 140, priority: .medium, startDate: Date(), createdAt: Date()),
            Task(title: "Schedule workers", isCompleted: false, durationInDays: 200, priority: .medium, startDate: Date(), createdAt: Date())
        ]
        
        // Sample data for team members
        teamMembers = [
            TeamMember(name: "John Doe", role: "Site Manager"),
            TeamMember(name: "Jane Smith", role: "Engineer")
        ]
        
        updateProgress()
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        updateProgress()
    }
    
    func removeTask(at index: Int) {
        tasks.remove(at: index)
        updateProgress()
    }
    
    func addTeamMember(_ member: TeamMember) {
        teamMembers.append(member)
    }
    
    func removeTeamMember(at index: Int) {
        teamMembers.remove(at: index)
    }
    
    private func updateProgress() {
        let completedTasks = tasks.filter { $0.isCompleted }.count
        progress = tasks.isEmpty ? 0.0 : Double(completedTasks) / Double(tasks.count)
    }
    
    func saveData() {
        let encoder = JSONEncoder()
        if let encodedTasks = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        }
    }
    
    func loadData() {
        let decoder = JSONDecoder()
        if let savedTasks = UserDefaults.standard.data(forKey: "tasks"),
           let decodedTasks = try? decoder.decode([Task].self, from: savedTasks) {
            tasks = decodedTasks
        }
    }
}
