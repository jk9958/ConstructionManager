import SwiftUI

struct DailyLogView: View {
    @State private var logs: [DailyLog] = []
    @State private var newProgress: String = ""

    private var canAdd: Bool {
        !newProgress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack {
            List {
                ForEach(logs) { log in
                    VStack(alignment: .leading) {
                        Text(log.date, style: .date)
                            .font(.headline)
                        Text(log.progress)
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: deleteLogs)
            }

            HStack {
                TextField("Add progress log", text: $newProgress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addLog) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .disabled(!canAdd)
            }
            .padding()
        }
        .navigationTitle("Daily Logs")
        .onAppear(perform: loadLogs)
    }

    private func loadLogs() {
        logs = CoreDataManager.shared.fetchDailyLogs()
    }

    private func addLog() {
        let trimmed = newProgress.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let log = DailyLog(date: Date(), progress: trimmed)
        CoreDataManager.shared.createDailyLog(log)
        newProgress = ""
        loadLogs()
    }

    private func deleteLogs(at offsets: IndexSet) {
        for index in offsets where logs.indices.contains(index) {
            CoreDataManager.shared.deleteDailyLog(logs[index])
        }
        loadLogs()
    }
}

#Preview {
    NavigationStack {
        DailyLogView()
    }
}
