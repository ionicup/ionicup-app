import SwiftUI

struct TournamentView: View {
    
    let tournament: Tournament
    
    var body: some View {
        NavigationStack {
            content(tournament: tournament)
                .navigationDestination(for: Tournament.self) { tournament in
                    content(tournament: tournament)
                }
        }
    }
    
    func content(tournament: Tournament) -> some View {
        List {
            switch tournament.mode {
            case .phases:
                Section("Fasi") {
                    ForEach(tournament.children) { tournament in
                        NavigationLink("\(tournament.displayName)", value: tournament)
                    }
                }
            case .groups:
                Section("Gruppi") {
                    ForEach(tournament.children) { tournament in
                        NavigationLink("\(tournament.displayName)", value: tournament)
                    }
                }
            case .multilevel:
                Text("Multilevel")
            case .roundrobin:
                Text("Roundrobin")
            }
        }
        .navigationTitle(tournament.displayName)
    }
}

#Preview {
    TournamentView(tournament: .ionicup2024)
        .modelContainer(.preview)
}
