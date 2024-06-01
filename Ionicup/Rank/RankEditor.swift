import SwiftUI
import OSLog

private let logger = Logger(subsystem: "Ionicup", category: "Rank Editor")

struct RankEditor: View {
    
    @Bindable var rank: Rank
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Form {
            Section("Mode") {
                Picker("Mode", selection: $rank.mode) {
                    ForEach(Rank.Mode.allCases, id: \.self) { mode in
                        switch mode {
                        case .seeded:
                            Text("Seeded")
                        case .rank:
                            Text("Rank")
                        case .winner:
                            Text("Winner")
                        case .looser:
                            Text("Looser")
                        case .placement:
                            Text("Placement")
                        }
                    }
                }
            }
            
            switch rank.mode {
            case .seeded:
                Section("Team") {
                    Picker("Team", selection: $rank.seededTeam) {
                        Text("Undefined")
                            .tag(Team?.none)
                        
                        ForEach(rank.selectableTeams) { team in
                            Text(team.name)
                                .tag(team as Optional)
                        }
                    }
                }
            case .rank:
                Section("Rank") {
                    Picker("Rank", selection: $rank.parent) {
                        Text("Undefined")
                            .tag(Rank?.none)
                        
                        ForEach(rank.selectableRanks) { rank in
                            Text(rank.displayDescription)
                                .tag(rank as Optional)
                        }
                    }
                }
            case .winner, .looser:
                Section("Match") {
                    Picker("Match", selection: $rank.match) {
                        Text("Undefined")
                            .tag(Match?.none)
                        
                        ForEach(rank.tournament?.matches ?? []) { match in
                            Text(match.displayName)
                                .tag(match as Optional)
                        }
                    }
                }
            case .placement:
                Section("Placement") {
                    Picker("Placement", selection: $rank.placement) {
                        Text("Undefined")
                            .tag(Int?.none)
                        
                        ForEach(0..<(rank.tournament?.initialRanks.count ?? 0), id: \.self) { placement in
                            Text(String(placement + 1))
                                .tag(placement as Optional)
                        }
                    }
                }
            }
        }
#if os(macOS)
        .padding()
#endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit rank")
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
        RankEditor(rank: Rank(mode: .seeded))
    }
    .modelContainer(.preview)
}
