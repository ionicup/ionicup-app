import SwiftUI
import SwiftData
import Algorithms

struct MatchList: View {
    
    private let matchesByDate: [Date: [Match]]
    
    @State private var editingMatch: Match?
    
    @State private var presentingMatch: Match?
    
    init(matches: [Match]) {
        self.matchesByDate = [.now: matches]//matches.grouped(by: \.date)
        print(matchesByDate)
    }
    
    var body: some View {
        ScrollView {
            ForEach(Array(matchesByDate.keys), id: \.self) { date in
                if let matches = matchesByDate[date] {
                    DisclosureGroup {
                        ForEach(matches) { match in
                            Button {
                                presentingMatch = match
                            } label: {
                                MatchRow(match: match)
                            }
                            .buttonStyle(.matchRow)
                        }
                    } label: {
                      Text(date, format: .verbatim("\(weekday: .wide) • \(hour: .defaultDigits(clock: .twentyFourHour, hourCycle: .oneBased)):\(minute: .twoDigits)", timeZone: TimeZone.current, calendar: Calendar.current))
                    }
                    .disclosureGroupStyle(.pile(alwaysExpanded: false))
                    .padding([.horizontal, .bottom])
                }
            }
        }
        .sheet(item: $presentingMatch) { match in
            MatchView(match: match)
                .presentationDetents([.medium, .large])
        }
        .sheet(item: $editingMatch) { match in
            MatchView(match: match)
                .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    EscapingView {
        MatchList(matches: [.liveMatch, .pastMatch, .upcomingMatch])
    }
    .modelContainer(.preview)
}
