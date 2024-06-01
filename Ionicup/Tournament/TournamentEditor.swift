import SwiftUI
import OSLog

private let logger = Logger(subsystem: "Ionicup", category: "Tournament Editor")

struct TournamentEditor: View {

    @Bindable var tournament: Tournament

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Form {
            Section("Name") {
                TextField("Display Name", text: $tournament.displayName)
                    .disableAutocorrection(true)
#if !os(macOS)
                    .textInputAutocapitalization(.sentences)
#endif
            }

            Section("Mode") {
                Picker("Mode", selection: $tournament.mode) {
                    ForEach(Tournament.Mode.allCases, id: \.self) { mode in
                        switch mode {
                        case .phases:
                            Text("Phases")
                        case .groups:
                            Text("Groups")
                        case .multilevel:
                            Text("Multilevel")
                        case .roundrobin:
                            Text("Roundrobin")
                        }
                    }
                }
            }

            Section("Initial Ranks") {
                ForEach(tournament.initialRanks) { rank in
                    NavigationLink(value: rank) {
                        RankRow(rank: rank)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(tournament.initialRanks[index])
                    }
                    tournament.initialRanks.remove(atOffsets: indexSet)
                }
                .onMove { source, destination in
                    tournament.initialRanks.move(fromOffsets: source, toOffset: destination)
                }

                Button("Add Rank") {
                    let newRank = Rank(mode: .seeded)
                    modelContext.insert(newRank)
                    tournament.initialRanks.append(newRank)
                }

              if let teams = tournament.season?.teams, !teams.isEmpty {
                Button("Generate ranks seeded from teams") {
                  for team in teams {
                    let newRank = Rank(mode: .seeded, seededTeam: team)
                    modelContext.insert(newRank)
                    tournament.initialRanks.append(newRank)
                  }
                }
              }

              let ranks = tournament.selectableInitialRanks
              if !ranks.isEmpty {
                Button("Generate ranks from selectable ranks") {
                  for rank in ranks {
                    let newRank = Rank(mode: .rank, parent: rank)
                    modelContext.insert(newRank)
                    tournament.initialRanks.append(newRank)
                  }
                }
              }
            }

            switch tournament.mode {
            case .phases:
                Section("Phases") {
                    ForEach(tournament.children) { tournament in
                        NavigationLink(tournament.displayName, value: tournament)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            modelContext.delete(tournament.children[index])
                        }
                        tournament.children.remove(atOffsets: indexSet)
                    }
                    .onMove { source, destination in
                        tournament.children.move(fromOffsets: source, toOffset: destination)
                    }

                    Button("Add Tournament") {
                        let newTournament = Tournament(displayName: "Phase \(tournament.children.count + 1)", mode: .phases)
                        modelContext.insert(newTournament)
                        tournament.children.append(newTournament)
                    }
                }
            case .groups:
                Section("Groups") {
                    ForEach(tournament.children) { tournament in
                        NavigationLink(tournament.displayName, value: tournament)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            modelContext.delete(tournament.children[index])
                        }
                        tournament.children.remove(atOffsets: indexSet)
                    }
                    .onMove { source, destination in
                        tournament.children.move(fromOffsets: source, toOffset: destination)
                    }

                    Button("Add Tournament") {
                        let newTournament = Tournament(displayName: "Group \(tournament.children.count + 1)", mode: .phases)
                        modelContext.insert(newTournament)
                        tournament.children.append(newTournament)
                    }
                }
            case .multilevel, .roundrobin:
                Section("Matches") {
                    ForEach(tournament.matches) { match in
                        NavigationLink(value: match) {
                            MatchRow(match: match)
                                .padding(.vertical)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            modelContext.delete(tournament.matches[index])
                        }
                        tournament.matches.remove(atOffsets: indexSet)
                    }
                    .onMove { source, destination in
                        tournament.matches.move(fromOffsets: source, toOffset: destination)
                    }

                  Button("Add Match") {
                    let match = Match()
                    modelContext.insert(match)
                    tournament.matches.append(match)
                  }

                  Button("Generate roundrobin matches") {
                    Task {
                      let pairs = TournamentAlgorithms.roundRobinPairs(teams: tournament.initialRanks)
                      for pair in pairs {
                        let match = Match(homeRank: pair.home, awayRank: pair.away)
                        modelContext.insert(match)
                        tournament.matches.append(match)
                        try await Task.sleep(for: .seconds(.leastNonzeroMagnitude))
                      }
                    }
                  }
                }
            }

            Section("Final Ranks") {
                ForEach(tournament.finalRanks) { rank in
                    NavigationLink(value: rank) {
                        RankRow(rank: rank)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(tournament.finalRanks[index])
                    }
                    tournament.finalRanks.remove(atOffsets: indexSet)
                }
                .onMove { source, destination in
                    tournament.finalRanks.move(fromOffsets: source, toOffset: destination)
                }

                Button("Add Rank") {
                    let rank = Rank(mode: .winner)
                    modelContext.insert(rank)
                    tournament.finalRanks.append(rank)
                }
            }
        }
#if os(macOS)
        .padding()
#endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit tournament")
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
        EscapingView {
            TournamentEditor(tournament: .ionicup2024)
        }
    }
    .modelContainer(.preview)
}
