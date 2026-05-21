import SwiftUI

struct DocumentListView: View {
    @StateObject private var vm = DocumentViewModel()
    var project: Project?
    @State private var isAdding = false
    @State private var showErrorAlert = false
    @State private var alertMessage: String? = nil

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.documents) { doc in
                    NavigationLink(destination: DocumentDetailView(document: doc)) {
                        VStack(alignment: .leading, spacing: DS.s) {
                            Text(doc.name)
                                .font(DS.body)
                                .foregroundColor(.primary)
                            if let desc = doc.documentDescription {
                                Text(desc)
                                    .font(DS.caption)
                                    .foregroundColor(DS.dim(0.6))
                            }
                        }
                        .padding(.vertical, DS.s)
                    }
                    .listRowBackground(Color.appCard)
                }
                .onDelete { indices in
                    indices.forEach { idx in
                        vm.deleteDocument(vm.documents[idx])
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Documents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isAdding = true }) { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $isAdding) {
                AddDocumentView(project: project) { newDoc in
                    let success = vm.addDocument(newDoc, forProjectId: project?.id)
                    if !success {
                        alertMessage = vm.errorMessage
                        showErrorAlert = true
                    }
                }
            }
            .onAppear { vm.loadDocuments(forProjectId: project?.id) }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
    }
}
