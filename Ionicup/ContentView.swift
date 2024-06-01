import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var seasons: [Season]
    
    @State private var season: Season?
    
    var body: some View {
        NavigationStack {
            VStack {
                if let season = seasons.first {
                    SeasonView(season: season)
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button {
                                    self.season = season
                                } label: {
                                    Label("Edit season", systemImage: "pencil")
                                }
                            }
                        }
                } else {
                    ProgressView()
                        .onAppear {
                            let newSeason = Season(displayName: "New season")
                            modelContext.insert(newSeason)
                        }
                }
            }
        }
        .sheet(item: $season) { season in
            NavigationStack {
                SeasonEditor(season: season)
                    .navigationDestination(for: Event.self) { event in
                        EventEditor(event: event)
                    }
                    .navigationDestination(for: Tournament.self) { tournament in
                        TournamentEditor(tournament: tournament)
                    }
                    .navigationDestination(for: Court.self) { court in
                        CourtEditor(court: court)
                    }
                    .navigationDestination(for: Rank.self) { rank in
                        RankEditor(rank: rank)
                    }
                    .navigationDestination(for: Team.self) { team in
                        TeamEditor(team: team)
                    }
                    .navigationDestination(for: Match.self) { match in
                        MatchEditor(match: match)
                    }
            }
        }
    }
}

#Preview {
    return ContentView()
        .modelContainer(.preview)
}

