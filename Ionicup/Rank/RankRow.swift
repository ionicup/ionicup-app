import SwiftUI

struct RankRow: View {
    
    var rank: Rank
    
    var body: some View {
        HStack {
            Text("#\(rank.tournamentSortOrder.map { String($0 + 1) } ?? "??")")
                .monospaced()
            
            switch rank.mode {
            case .seeded:
                Text(rank.team?.name ?? "Seeded: undefined")
            case .rank:
                Text(rank.parent?.displayDescription ?? "Rank: undefined")
            case .winner:
                Text("Winner: \(rank.match?.displayName ?? "undefined")")
            case .looser:
                Text("Looser: \(rank.match?.displayName ?? "undefined")")
            case .placement:
                Text("Placement: \(rank.placement.map { String($0 + 1) } ?? "undefined")")
            }
        }
    }
}

#Preview {
    RankRow(rank: Rank(mode: .seeded))
        .modelContainer(.preview)
}
