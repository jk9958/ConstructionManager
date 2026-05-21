import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    var project: Project

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var durationInDays: Int = 1
    @State private var priority: TaskPriority = .medium
    @State private var showErrorAlert = false
    @State private var alertMessage: String? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $description)
                        .frame(minHeight: 100, maxHeight: 160)
                        .padding(8)
                        .background(Color.appCard)
                        .cornerRadius(DS.cornerRadius)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(false)
                        .accessibilityLabel("Task description")
                        .overlay(
                            Group {
                                if description.isEmpty {
                                    Text("Enter task description...")
                                        .foregroundColor(DS.dim(0.6))
                                        .padding(.leading, 6)
                                        .padding(.top, 8)
                                }
                            }, alignment: .topLeading
                        )
                    Stepper("Duration: \(durationInDays) days", value: $durationInDays, in: 1...365)
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation(.easeInOut) { saveTask() }
                    }
                    .disabled(title.isEmpty)
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Save Failed"), message: Text(alertMessage ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
        }
    }

    private func saveTask() {
        let newTask = Task(
            id: UUID(),
            title: title,
            taskDescription: description.isEmpty ? "No description provided" : description,
            isCompleted: false,
            durationInDays: durationInDays,
            assignedTo: [],
            priority: priority,
            deadline: Date().addingTimeInterval(Double(durationInDays) * 86400),
            status: .notStarted,
            startDate: Date(),
            createdAt: Date(),
            updatedAt: nil
        )
        let success = CoreDataManager.shared.createTask(from: newTask, forProjectId: project.id)
        if success {
            dismiss()
        } else {
            alertMessage = "Failed to save task. Please try again."
            showErrorAlert = true
        }
    }

    
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .topLeading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
