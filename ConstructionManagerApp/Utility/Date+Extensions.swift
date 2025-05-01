import Foundation

extension DateFormatter {
    static let projectDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

extension Date {
    /// Calculates the number of days between the current date and another date.
    /// - Parameter otherDate: The date to compare with.
    /// - Returns: The number of days between the two dates.
    func daysBetween(_ otherDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfSelf = calendar.startOfDay(for: self)
        let startOfOtherDate = calendar.startOfDay(for: otherDate)
        let components = calendar.dateComponents([.day], from: startOfSelf, to: startOfOtherDate)
        return components.day ?? 0
    }
    
    var oneYearLater: Date {
        Calendar.current.date(byAdding: .year, value: 1, to: self) ?? self
    }
}
