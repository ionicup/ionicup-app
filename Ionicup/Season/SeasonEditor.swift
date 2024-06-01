import SwiftUI
import OSLog

private let logger = Logger(subsystem: "Ionicup", category: "Season Editor")

struct SeasonEditor: View {
    
    @Bindable var season: Season
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Display Name", text: $season.displayName)
                    .disableAutocorrection(true)
#if !os(macOS)
                    .textInputAutocapitalization(.sentences)
#endif
            }
#if !os(macOS)
            Section("Dates") {
                MultiDatePicker("Dates", selection: $season.dates)
            }
#endif
            Section("Events") {
                ForEach(season.events) { event in
                    NavigationLink(event.name, value: event)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(season.events[index])
                    }
                    season.events.remove(atOffsets: indexSet)
                }
                .onMove { source, destination in
                    season.events.move(fromOffsets: source, toOffset: destination)
                }
                
                Button("Add Event") {
                  let date = season.events.last?.date ?? season.dates.first?.date
                  let event = Event(displayName: "Event \(season.events.count + 1)", date: date ?? .now)
                    modelContext.insert(event)
                    season.events.append(event)
                }

              Button("Order events by date") {
                withAnimation {
                  season.events.sort(using: SortDescriptor(\.date))
                }
              }
            }
            
            Section("Courts") {
                ForEach(season.courts) { court in
                    NavigationLink(court.displayName, value: court)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(season.courts[index])
                    }
                    season.courts.remove(atOffsets: indexSet)
                }
                .onMove { source, destination in
                    season.courts.move(fromOffsets: source, toOffset: destination)
                }
                
                Button("Add Court") {
                    let court = Court(displayName: "Court \(season.courts.count + 1)")
                    modelContext.insert(court)
                    season.courts.append(court)
                }
            }
            
            Section("Teams") {
                ForEach(season.teams) { team in
                    NavigationLink(team.name, value: team)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(season.teams[index])
                    }
                    season.teams.remove(atOffsets: indexSet)
                }
                .onMove { source, destination in
                    season.teams.move(fromOffsets: source, toOffset: destination)
                }
                
                Button("Add Teams") {
                    let team = Team(name: "Team \(season.teams.count + 1)", compactName: "Team \(season.teams.count + 1)")
                    modelContext.insert(team)
                    season.teams.append(team)
                }
            }
            
            Section("Tournaments") {
                ForEach(season.tournaments) { tournament in
                    NavigationLink(tournament.displayName, value: tournament)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(season.tournaments[index])
                    }
                    season.tournaments.remove(atOffsets: indexSet)
                }
                .onMove { source, destination in
                    season.tournaments.move(fromOffsets: source, toOffset: destination)
                }
                
                Button("Add Tournament") {
                    let tournament = Tournament(displayName: season.displayName, mode: .phases)
                    modelContext.insert(tournament)
                    season.tournaments.append(tournament)
                }
            }
        }
#if os(macOS)
        .padding()
#endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit season")
                    .fontWeight(.semibold)
            }
        }
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

#Preview {
    SeasonEditor(season: .ionicup2024)
        .modelContainer(.preview)
}
