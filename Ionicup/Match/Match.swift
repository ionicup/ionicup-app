import Foundation
import SwiftData
import OSLog
import Algorithms

private let logger = Logger(subsystem: "Ionicup", category: "Match")

@Model
class Match {
    
    @Relationship(deleteRule: .nullify, inverse: \Rank.homeMatches)
    var homeRank: Rank?
    
    @Relationship(deleteRule: .nullify, inverse: \Rank.awayMatches)
    var awayRank: Rank?
    
    var rules: MatchRules

    var events: [MatchEvent] = []

    var tournament: Tournament?
    var tournamentSortOrder: Int?

  init(homeRank: Rank? = nil, awayRank: Rank? = nil, rules: MatchRules = .fip, events: [MatchEvent] = [], tournament: Tournament? = nil, tournamentSortOrder: Int? = nil) {
        self.homeRank = homeRank
        self.awayRank = awayRank
        self.rules = rules
        self.events = events
        self.tournament = tournament
        self.tournamentSortOrder = tournamentSortOrder
        
        logger.notice("Match has been created.")
    }
}

extension Match {
    
    var displayName: String {
        "\(homeRank?.displayDescription ?? "Undefined") - \(awayRank?.displayDescription ?? "Undefined")"
    }

    var homeTeamScore: Int {
        events.map { event in
            switch event {
            case .addBasket(let basket, id: _) where basket.team == .home:
                basket.point.value
            default:
                0
            }
        }.reduce(0, +)
    }

    var awayTeamScore: Int {
        events.map { event in
            switch event {
            case .addBasket(let basket, id: _) where basket.team == .away:
                basket.point.value
            default:
                0
            }
        }.reduce(0, +)
    }
    
    var score: MatchScore? {
        MatchScore([])
    }
}

struct MatchScore {

    private let periodPoints: [(home: Int, away: Int, periodKind: MatchPeriod.Kind)]

    init(_ periodPoints: some Collection<(home: Int, away: Int, periodKind: MatchPeriod.Kind)>) {
        self.periodPoints = Array(periodPoints)
    }

    subscript(period: MatchPeriod) -> (home: Int, away: Int) {
        let periodPoints = self[Int(period.value)]
        return (periodPoints.home, periodPoints.away)
    }

    var total: (home: Int, away: Int) {
        periodPoints.reduce((home: 0, away: 0)) { ($0.home + $1.home, $0.away + $1.away) }
    }

    var regularTotal: (home: Int, away: Int) {
        periodPoints.reduce((home: 0, away: 0)) { ($0.home + $1.home, $0.away + $1.away) }
    }

    var result: MatchResult {
        let total = total
        if total.home > total.away {
            return .homeWin
        } else if total.home < total.away {
            return .awayWin
        } else {
            return .tie
        }
    }
}

extension MatchScore: RandomAccessCollection {

    var startIndex: Int {
        periodPoints.startIndex
    }

    var endIndex: Int {
        periodPoints.endIndex
    }

    subscript(position: Int) -> (home: Int, away: Int, periodKind: MatchPeriod.Kind) {
        periodPoints[position]
    }
}

extension MatchScore: ExpressibleByArrayLiteral {

    init(arrayLiteral elements: (home: Int, away: Int, periodKind: MatchPeriod.Kind)...) {
        self.periodPoints = elements
    }
}

struct MatchEffectiveScoreEvaluator: Codable, Hashable {

    var rule: Rule

    enum Rule: Codable {
        case scored
        case win3Tie2Lose1
    }

    func evaluate(score: MatchScore) -> MatchScore {
        switch rule {
        case .scored:
            score
        case .win3Tie2Lose1:
            MatchScore(
                score.map { (home, away, periodKind) in
                    if home > away {
                        (3, 1, periodKind)
                    } else if home < away {
                        (1, 3, periodKind)
                    } else {
                        (2, 2, periodKind)
                    }
                }
            )
        }
    }
}

struct MatchResultEstabisher: Codable, Hashable {

    var rule: Rule

    enum Rule: Codable, CaseIterable {
        case effectiveThanScored
        case effective
        case scored
    }

    func establish(score: MatchScore, effectiveScoreEvaluator: MatchEffectiveScoreEvaluator) -> MatchResult {
        switch rule {
        case .effectiveThanScored:
            let effectiveResult = effectiveScoreEvaluator.evaluate(score: score).result
            if effectiveResult == .tie {
                return score.result
            } else {
                return effectiveResult
            }
        case .effective:
            return effectiveScoreEvaluator.evaluate(score: score).result
        case .scored:
            return score.result
        }
    }
}

enum MatchResult: Codable {
    case homeWin
    case awayWin
    case tie
}

struct MatchPeriod: Codable, Hashable {

    let value: Int

    let kind: Kind

    enum Kind: Codable {
        case regular
        case overtime
    }
}

extension MatchPeriod: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.value = value
        self.kind = .regular
    }
}

enum MatchTeam: Codable {
    case home
    case away
}

extension Match {
    
    var winnerTeam: Team? {
        fatalError()
    }
    
    var looserTeam: Team? {
        fatalError()
    }
}
