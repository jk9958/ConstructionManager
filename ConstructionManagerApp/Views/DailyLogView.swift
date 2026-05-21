import SwiftUI

struct DailyLog: Identifiable {
    var id = UUID()
    var date: Date
    var progress: String
}

struct DailyLogView: View {
    @State private var logs: [DailyLog] = [
        DailyLog(date: Date(), progress: "Foundation completed"),
        DailyLog(date: Date().addingTimeInterval(-86400), progress: "Materials delivered")
    ]
    @State private var newProgress: String = ""

    var body: some View {
        VStack {
            List(logs) { log in
                VStack(alignment: .leading) {
                    Text(log.date, style: .date)
                        .font(.headline)
                    Text(log.progress)
                        .font(.subheadline)
                }
            }

            HStack {
                TextField("Add progress log", text: $newProgress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if !newProgress.isEmpty {
                        logs.append(DailyLog(date: Date(), progress: newProgress))
                        newProgress = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle("Daily Logs")
    }
}

#Preview {
    DailyLogView()
}