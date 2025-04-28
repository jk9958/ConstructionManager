import SwiftUI
import UniformTypeIdentifiers

struct TeamMember: Identifiable {
    var id = UUID()
    var name: String
    var role: String
}

struct TeamView: View {
    @State private var teamMembers: [TeamMember] = [
        TeamMember(name: "John Doe", role: "Site Manager"),
        TeamMember(name: "Jane Smith", role: "Engineer")
    ]

    var body: some View {
        List(teamMembers) { member in
            VStack(alignment: .leading) {
                Text(member.name)
                    .font(.headline)
                Text(member.role)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Team Members")
    }
}

struct FileUploadView: View {
    @State private var uploadedFiles: [URL] = []

    var body: some View {
        VStack {
            List(uploadedFiles, id: \.self) { file in
                Text(file.lastPathComponent)
            }

            Button("Upload File") {
                DocumentPicker { url in
                    if let url = url {
                        uploadedFiles.append(url)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("File Uploads")
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL?) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.content])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL?) -> Void

        init(onPick: @escaping (URL?) -> Void) {
            self.onPick = onPick
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onPick(urls.first)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onPick(nil)
        }
    }
}

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                NavigationLink(destination: DailyLogView()) {
                    HStack {
                        Text("Daily Logs")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(8)
                }

                NavigationLink(destination: TeamView()) {
                    HStack {
                        Text("Team Management")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
                }

                NavigationLink(destination: FileUploadView()) {
                    HStack {
                        Text("File Uploads")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Main Menu")
        }
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}