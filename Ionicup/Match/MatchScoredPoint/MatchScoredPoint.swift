import Foundation

struct MatchScoredPoint: Codable, Hashable {

    let value: Int

    let kind: Kind

    enum Kind: Codable {
        case freeThrow
        case shortRange
        case longRange
        case ownBasket
    }
}

extension MatchScoredPoint {

    static var basketFreeThrow: MatchScoredPoint {
        MatchScoredPoint(value: 1, kind: .freeThrow)
    }

    static var basketShortRange: MatchScoredPoint {
        MatchScoredPoint(value: 2, kind: .shortRange)
    }

    static var basketLongRange: MatchScoredPoint {
        MatchScoredPoint(value: 3, kind: .longRange)
    }

    static var basketOwnBasket: MatchScoredPoint {
        MatchScoredPoint(value: 2, kind: .ownBasket)
    }

    static var basket: [MatchScoredPoint] {
        [.basketFreeThrow, .basketShortRange, .basketLongRange, .basketOwnBasket]
    }

    static var streetballFreeThrow: MatchScoredPoint {
        MatchScoredPoint(value: 1, kind: .freeThrow)
    }

    static var streetballShortRange: MatchScoredPoint {
        MatchScoredPoint(value: 1, kind: .shortRange)
    }

    static var streetballLongRange: MatchScoredPoint {
        MatchScoredPoint(value: 2, kind: .longRange)
    }

    static var streetballOwnBasket: MatchScoredPoint {
        MatchScoredPoint(value: 1, kind: .ownBasket)
    }

    static var streetball: [MatchScoredPoint] {
        [.streetballFreeThrow, .streetballShortRange, .streetballLongRange, .streetballOwnBasket]
    }
    static var minibasketFreeThrow: MatchScoredPoint {
        MatchScoredPoint(value: 1, kind: .freeThrow)
    }

    static var minibasketShortRange: MatchScoredPoint {
        MatchScoredPoint(value: 2, kind: .shortRange)
    }

    static var minibasketOwnBasket: MatchScoredPoint {
        MatchScoredPoint(value: 2, kind: .ownBasket)
    }

    static var minibasket: [MatchScoredPoint] {
        [.minibasketFreeThrow, .minibasketShortRange, .minibasketOwnBasket]
    }
}
