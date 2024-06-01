import Foundation
import SwiftData

extension Match {

    static let pastMatch = Match(/*homeTeam: .noHops, awayTeam: .ballHogz, date: Calendar.current.date(byAdding: .day, value: -3, to: .now)!, */events: [
//        .addBasket(.init(team: .home, point: .basketFreeThrow), id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!),
//        .addBasket(.init(team: .away, point: .basketLongRange), id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!)
    ])

    static let liveMatch = Match(/*homeTeam: .noHops, awayTeam: .ballHogz, date: .now, */events: [
//        .addBasket(.init(team: .home, point: .basketFreeThrow), id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!),
//        .addBasket(.init(team: .away, point: .basketLongRange), id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!)
    ])

    static let upcomingMatch = Match(/*homeTeam: .noHops, awayTeam: .ballHogz, date: Calendar.current.date(byAdding: .day, value: 9, to: .now)!, */events: [])

    static func insertSampleData(modelContext: ModelContext) {
        modelContext.insertSampleData(pastMatch)
        modelContext.insertSampleData(liveMatch)
        modelContext.insertSampleData(upcomingMatch)
    }
}
