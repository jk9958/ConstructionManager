import SwiftUI

struct DailyLog: Identifiable {
    var id = UUID()
    var date: Date
    var progress: String
    var photo: Image?
}

struct DailyLogView: View {
    @State private var logs: [DailyLog] = [
        DailyLog(date: Date(), progress: "Foundation completed", photo: nil),
        DailyLog(date: Date().addingTimeInterval(-86400), progress: "Materials delivered", photo: nil)
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
                        logs.append(DailyLog(date: Date(), progress: newProgress, photo: nil))
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

struct DailyLogView_Previews: PreviewProvider {
    static var previews: some View {
        DailyLogView()
    }
}