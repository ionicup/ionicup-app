import SwiftUI

struct MatchEventsEditorSection: View {

    @Binding var events: [MatchEvent]

    var body: some View {
        Section("Match events") {
            ForEach(events) { event in
                switch event {
                case .setTimer(let timer, id: _):
                    GroupBox("Timer set") {
                        LabeledContent(
                            "Interval",
                            value: timer.interval.lowerBound..<timer.interval.upperBound,
                            format: .interval
                        )
                        DatePicker("Test", selection: .constant(.now))
                        LabeledContent(
                            "Pause",
                            value: timer.pauseTime,
                            format: .dateTime
                        )
                        LabeledContent("Timer") {
                            Text(timerInterval: timer.interval, pauseTime: timer.pauseTime)
                        }
                    }
                    .groupBoxStyle(PlainGroupBoxStyle())
                case.addBasket(_, id: _):
                    EmptyView()
                }
            }
            
            Button("Add Set Timer Event") {
                events.append(.setTimer(MatchEvent.Timer(interval: .now...Date.now, pauseTime: .now, period: MatchPeriod(value: 1, kind: .regular)), id: UUID()))
            }
            
            Button("Add Basket Event") {
                events.append(.addBasket(MatchEvent.Basket(team: .home, point: .basketFreeThrow), id: UUID()))
            }
        }
    }
}

struct MatchEventTimerEditorSection: View {

    @Binding var timer: MatchEvent.Timer

    var body: some View {
        GroupBox("Timer set") {
            LabeledContent(
                "Interval",
                value: timer.interval.lowerBound..<timer.interval.upperBound,
                format: .interval
            )
            let startDateBinding = Binding {
                timer.interval.lowerBound
            } set: { startDate in
                timer.interval = startDate...timer.interval.upperBound
            }
            let endDateBinding = Binding {
                timer.interval.upperBound
            } set: { endDate in
                timer.interval = timer.interval.lowerBound...endDate
            }

            DatePicker("Start date", selection: startDateBinding)
            DatePicker("End date", selection: endDateBinding)
            LabeledContent(
                "Pause",
                value: timer.pauseTime,
                format: .dateTime
            )
            LabeledContent("Timer") {
                Text(timerInterval: timer.interval, pauseTime: timer.pauseTime)
            }
        }
    }
}

struct PlainGroupBoxStyle: GroupBoxStyle {

    func makeBody(configuration: Configuration) -> some View {
        VStack  {
            configuration.label.font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            configuration.content
        }
    }
}

#Preview {
    Preview(
        events: [
            .addBasket(.init(team: .away, point: .minibasketShortRange), id: UUID()),
            .setTimer(MatchEvent.Timer(interval: timerStart...timerEnd, pauseTime: pauseTime, period: .init(value: 1, kind: .regular)), id: UUID())
        ]
    )
}

let timerStart: Date = .now.addingTimeInterval(0)
let timerEnd: Date = timerStart.addingTimeInterval(60*5)
let pauseTime: Date = timerStart.addingTimeInterval(60*5)

private struct Preview: View {
    
    @State var events: [MatchEvent]

    var body: some View {
        Form {
            MatchEventsEditorSection(events: $events)
        }
    }
}
