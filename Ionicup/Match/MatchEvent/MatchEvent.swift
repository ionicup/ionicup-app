import Foundation

enum MatchEvent: Identifiable, Codable, Hashable {

    case addBasket(_ basket: Basket, id: UUID)
    case setTimer(_ timer: Timer, id: UUID)

    var id: UUID {
        switch self {
        case .addBasket(_, id: let id):
            id
        case .setTimer(_, id: let id):
            id
        }
    }
}

extension MatchEvent {

    struct Basket: Codable, Hashable {

        var team: MatchTeam

        var point: MatchScoredPoint
    }
}

extension MatchEvent {

    struct Timer: Codable, Hashable {

        var interval: ClosedRange<Date>

        var pauseTime: Date

        var period: MatchPeriod
    }
}
