import Foundation

struct MatchRules: Codable, Hashable {
    var regularPeriodCount: Int
    var overtimePeriodMaximumCount: Int
    var regularPeriodTimeInterval: TimeInterval
    var overtimePeriodTimeInterval: TimeInterval
    var resultEstablisher: MatchResultEstabisher
    var effectiveScoreEvaluator: MatchEffectiveScoreEvaluator
    var allowedScoredPoints: [MatchScoredPoint]
    var isTieAllowed: Bool
}

extension MatchRules {

    static private let defaultRegularPeriodCount = 6
    static private let defaultPeriodTimeInterval: TimeInterval = 5*60

    static var ionicupRoundRobin: MatchRules {
        MatchRules(
            regularPeriodCount: defaultRegularPeriodCount,
            overtimePeriodMaximumCount: 0,
            regularPeriodTimeInterval: defaultPeriodTimeInterval,
            overtimePeriodTimeInterval: defaultPeriodTimeInterval,
            resultEstablisher: MatchResultEstabisher(rule: .effective),
            effectiveScoreEvaluator: MatchEffectiveScoreEvaluator(rule: .win3Tie2Lose1),
            allowedScoredPoints: MatchScoredPoint.minibasket,
            isTieAllowed: true
        )
    }

    static var ionicupMultilevel: MatchRules {
        MatchRules(
            regularPeriodCount: defaultRegularPeriodCount,
            overtimePeriodMaximumCount: 99,
            regularPeriodTimeInterval: defaultPeriodTimeInterval,
            overtimePeriodTimeInterval: defaultPeriodTimeInterval,
            resultEstablisher: MatchResultEstabisher(rule: .effectiveThanScored),
            effectiveScoreEvaluator: MatchEffectiveScoreEvaluator(rule: .win3Tie2Lose1),
            allowedScoredPoints: MatchScoredPoint.minibasket,
            isTieAllowed: false
        )
    }

    static var ionicupFinal: MatchRules {
        MatchRules(
            regularPeriodCount: defaultRegularPeriodCount,
            overtimePeriodMaximumCount: 99,
            regularPeriodTimeInterval: defaultPeriodTimeInterval,
            overtimePeriodTimeInterval: defaultPeriodTimeInterval,
            resultEstablisher: MatchResultEstabisher(rule: .effective),
            effectiveScoreEvaluator: MatchEffectiveScoreEvaluator(rule: .win3Tie2Lose1),
            allowedScoredPoints: MatchScoredPoint.minibasket,
            isTieAllowed: false
        )
    }
}

extension MatchRules {

    static var fip: MatchRules {
        MatchRules(
            regularPeriodCount: 4,
            overtimePeriodMaximumCount: 99,
            regularPeriodTimeInterval: 60*10,
            overtimePeriodTimeInterval: 60*10,
            resultEstablisher: MatchResultEstabisher(rule: .scored),
            effectiveScoreEvaluator: MatchEffectiveScoreEvaluator(rule: .scored),
            allowedScoredPoints: MatchScoredPoint.basket,
            isTieAllowed: false
        )
    }
}
