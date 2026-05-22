import Foundation

struct DailyLog: Identifiable, Equatable {
    var id = UUID()
    var date: Date
    var progress: String
}
