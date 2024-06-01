import SwiftUI
import OSLog

private let logger = Logger(subsystem: "Ionicup", category: "Team Editor")

struct TeamEditor: View {
    
    @Bindable var team: Team
    
    var body: some View {
            Form {
                Section("Name") {
                    TextField("Name", text: $team.name)
                        .autocorrectionDisabled()
                }
                
                Section("Short Name") {
                    TextField("Short Name", text: $team.compactName)
                        .autocorrectionDisabled()
                }
            }
#if os(macOS)
            .padding()
#endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Edit team")
                        .fontWeight(.semibold)
                }
            }
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

#Preview {
    NavigationStack {
        TeamEditor(team: Team(name: "Name", compactName: "Compact Name"))
    }
    .modelContainer(.preview)
}
