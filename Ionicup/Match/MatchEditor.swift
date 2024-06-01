import SwiftUI
import OSLog

private let logger = Logger(subsystem: "Ionicup", category: "Match Editor")

struct MatchEditor: View {
    
    @Bindable var match: Match
    
    @State private var homeTeam: Team?
    @State private var awayTeam: Team?
    @State private var events: [MatchEvent] = []
    @State private var rules: MatchRules = .fip
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Form {
            Section("Teams") {
                Picker("Home Rank", selection: $match.homeRank) {
                    Text("Indefinita")
                        .tag(nil as Rank?)
                    
                    ForEach(match.tournament?.initialRanks ?? []) { rank in
                        Text(rank.displayDescription)
                            .tag(rank as Rank?)
                    }
                }
                
                Picker("Away Rank", selection: $match.awayRank) {
                    Text("Indefinita")
                        .tag(nil as Rank?)
                    
                    ForEach(match.tournament?.initialRanks ?? []) { rank in
                        Text(rank.displayDescription)
                            .tag(rank as Rank?)
                    }
                }
            }
            
            MatchRulesEditorSection(rules: $match.rules)

            MatchEventsEditorSection(events: $match.events)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit Match")
                    .fontWeight(.semibold)
            }
        }
#if os(macOS)
        .padding()
#endif
    }
}

#Preview {
    NavigationStack {
        MatchEditor(match: Match(events: []))
    }
    .modelContainer(.preview)
}
