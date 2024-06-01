import SwiftUI
import SwiftData
import Algorithms

struct EventList: View {

  var events: [Event]

  var eventSlots: [EventSlot] {
    events
      .grouped { $0.date ?? .distantFuture }
      .map { EventSlot(time: $0.key, events: $0.value) }
      .sorted(using: SortDescriptor(\.time))
  }

  var eventDays: [EventDay] {
    eventSlots
      .grouped { Calendar.current.startOfDay(for: $0.time) }
      .map { EventDay(day: $0.key, slots: $0.value) }
      .sorted(using: SortDescriptor(\.day))
  }

  @State private var presentingMatch: Match?

  var body: some View {
    if !events.isEmpty {
      TabView {
        ForEach(Array(eventDays.enumerated()), id: \.element.id) { (offset, eventDay) in
          ScrollView {
            Section {
              ForEach(eventDay.slots) { eventSlot in
                eventSlotRow(eventSlot)
                  .padding(.top)
              }
            } header: {
              Text(eventDay.day, format: .dateTime.weekday(.wide))
                .font(.title.bold())
                .foregroundStyle(.secondary)
//                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, -8)
            }
            .padding(.vertical)
            .padding(.horizontal)
          }
          .tabItem {
            Label(
              title: { Text(eventDay.day, format: .dateTime.weekday(.wide)) },
              icon: { Image(systemName: "\(offset + 1).circle") }
            )
          }
          .badge(Calendar.current.isDateInToday(eventDay.day) ? "" : nil)
        }
      }
      .sheet(item: $presentingMatch) { match in
        MatchView(match: match)
          .presentationDetents([.medium, .large])
      }
    } else {
      ContentUnavailableView("No events", systemImage: "figure.basketball")
    }
  }

  func eventSlotRow(_ eventSlot: EventSlot) -> some View {
    DisclosureGroup {
      ForEach(eventSlot.events) { event in
        eventRow(event)
      }
    } label: {
      Text(eventSlot.time, format: .dateTime.hour().minute())
    }
    .disclosureGroupStyle(.pile)
  }

  func eventRow(_ event: Event) -> some View {
    Group {
      if let match = event.match {
        Button {
          presentingMatch = match
        } label: {
          MatchRow(match: match)
        }
        .buttonStyle(.matchRow)
      } else {
          if let displayName = event.displayName, !displayName.isEmpty {
            GroupBox(displayName) {
              Text(event.displayDescription ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
            }
          } else {
            GroupBox {
              Text(event.displayDescription ?? "Undefined")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            }
          }
      }
    }
    .pileItemTitle(Text(event.court?.displayName ?? ""))
  }
}

struct EventDay: Hashable, Identifiable {
  var day: Date
  var slots: [EventSlot]

  var id: Date {
    day
  }
}

struct EventSlot: Hashable, Identifiable {
  var time: Date
  var events: [Event]

  var id: Date {
    time
  }
}

#Preview {
    EscapingView {
      EventList(events: [Event(date: .now, match: .liveMatch), Event(date: .now, match: .pastMatch), Event(date: .now, match: .upcomingMatch)])
    }
    .modelContainer(.preview)
}
