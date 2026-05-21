import SwiftUI

struct TeamListView: View {
    @StateObject private var vm = TeamViewModel()
    @State private var isAdding = false
    @State private var showErrorAlert = false
    @State private var alertMessage: String? = nil

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.teams) { team in
                    NavigationLink(destination: TeamDetailView(team: team)) {
                        Text(team.name ?? "Untitled Team")
                            .font(DS.body)
                            .padding(.vertical, DS.s)
                    }
                    .listRowBackground(Color.appCard)
                }
                .onDelete { indices in
                    // deletion not implemented yet in CoreDataManager
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Teams")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isAdding = true }) { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $isAdding) {
                AddTeamView { newTeam in
                    let success = vm.addTeam(newTeam)
                    if !success {
                        alertMessage = vm.errorMessage
                        showErrorAlert = true
                    }
                }
            }
            .onAppear { vm.loadTeams() }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
    }
}
