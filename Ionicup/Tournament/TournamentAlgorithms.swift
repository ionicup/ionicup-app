import Foundation
import Algorithms

//struct TournamentAlgorithms {
//    
//    static func roundRobinModeSchedule(teams: [Team]) -> Schedule {
//        Schedule(rounds: [roundRobinModeRound(teams: teams)])
//    }
//    
//    static func roundRobinModeRound(teams: [Team]) -> Round {
//        guard teams.count > 1 else {
//            return Round(matches: [], standings: teams)
//        }
//        
//        var matches: [Match] = []
//        for combination in teams.combinations(ofCount: 2) {
//            let teamA = combination[0]
//            let teamB = combination[1]
//            let match: Match
//            if teamA.expectedRank <= teamB.expectedRank {
//                match = Match(homeTeam: teamA, awayTeam: teamB)
//            } else {
//                match = Match(homeTeam: teamB, awayTeam: teamA)
//            }
//            matches.append(match)
//        }
//        return Round(matches: matches, standings: (1...teams.count).map { .ranked($0) })
//    }
//    
//    static func eliminationModeSchedule(teams: [Team]) -> Schedule {
//        let roundsCount = Int(max(0, log2(Double(teams.count)).rounded(.up)))
//        let completeTeamsCount = Int(pow(2.0, Double(roundsCount)))
//        
//        var rounds: [Round] = []
//        for i in 0..<roundsCount {
//            let lastRound = rounds.last ?? Round(matches: [], standings: teams)
//            
//            let roundSize = completeTeamsCount / Int(pow(2.0, Double(i)))
//            let teamsChunks = lastRound.standings.chunks(ofCount: roundSize)
//            let partialRound = eliminationModeRound(teams: Array(teamsChunks.first ?? []))
//            let round = Round(matches: partialRound.matches, standings: partialRound.standings + Array(teamsChunks.dropFirst().joined()))
//            
//            rounds.append(round)
//        }
//        
//        return Schedule(rounds: rounds)
//    }
//    
//    static func multilevelModeSchedule(teams: [Team]) -> Schedule {
//        let roundsCount = Int(max(0, log2(Double(teams.count)).rounded(.up)))
//        let completeTeamsCount = Int(pow(2.0, Double(roundsCount)))
//        
//        var rounds: [Round] = []
//        for i in 0..<roundsCount {
//            let lastRound = rounds.last ?? Round(matches: [], standings: teams)
//            
//            let roundSize = completeTeamsCount / Int(pow(2.0, Double(i)))
//            let innerRounds = lastRound.standings.chunks(ofCount: roundSize).map { eliminationModeRound(teams: Array($0)) }
//            
//            let round = innerRounds.reduce(Round(matches: [], standings: [])) { partialResult, round in
//                return Round(matches: partialResult.matches + round.matches, standings: partialResult.standings + round.standings)
//            }
//            rounds.append(round)
//        }
//        
//        return Schedule(rounds: rounds)
//    }
//
//    // Le squadre vengono accoppiate tipo la prima con l'ultima
//    static func eliminationModeRound(teams: [Team]) -> Round {
//        guard teams.count > 1 else {
//            return Round(matches: [], standings: teams)
//        }
//        
//        let roundsCount = Int(max(0, log2(Double(teams.count)).rounded(.up)))
//        
//        let completeTeamsCount = Int(pow(2.0, Double(roundsCount)))
//        // Numero di partite se il numero di squadre fosse la successiva potenza di due.
//        let roundSize = completeTeamsCount / 2
//        
//        var matches: [Match] = []
//        var winnerTeams: [Team] = []
//        var looserTeams: [Team] = []
//        
//        for i in 0..<roundSize {
//            let homeTeamIndex = teams.index(teams.startIndex, offsetBy: i, limitedBy: teams.endIndex-1)
//            let awayTeamIndex = teams.index(teams.startIndex, offsetBy: completeTeamsCount-1-i, limitedBy: teams.endIndex-1)
//            
//            switch (homeTeamIndex, awayTeamIndex) {
//            case (.some(let homeTeamIndex), .some(let awayTeamIndex)):
//                let match = Match(homeTeam: teams[homeTeamIndex], awayTeam: teams[awayTeamIndex])
//                matches.append(match)
//                winnerTeams.append(.winner(match: match))
//                looserTeams.insert(.looser(match: match), at: looserTeams.startIndex)
//            case (.some(let homeTeamIndex), .none):
//                winnerTeams.append(teams[homeTeamIndex])
//            default:
//                fatalError("This case should not be possible")
//            }
//        }
//        return Round(matches: matches, standings: winnerTeams+looserTeams)
//    }
//
//    struct Schedule: CustomStringConvertible {
//
//        let rounds: [Round]
//
//        var standings: [Team] {
//            rounds.last?.standings ?? []
//        }
//
//        var description: String {
//            let matches = rounds.map(\.matches).joined().enumerated()
//            func teamDescription(team: Team) -> String {
//                switch team {
//                case .ranked(let rank):
//                    "rank(\(rank))"
//                case .winner(let match):
//                    "winner(\((matches.first(where: { $0.element === match })?.offset ?? -2) + 1))~\(team.expectedRank)"
//                case .looser(let match):
//                    "looser(\((matches.first(where: { $0.element === match })?.offset ?? -2) + 1))~\(team.expectedRank)"
//                }
//            }
//            var description = ""
//            for (i, round) in rounds.enumerated() {
//                description.append("\nRound \(i+1)\n")
//
//                for match in round.matches {
//                    let matchID = matches.first(where: { $0.element === match })!.offset
//                    description.append("Match \(matchID+1) | \(teamDescription(team: match.homeTeam)) - \(teamDescription(team: match.awayTeam))\n")
//                }
//            }
//            description.append("\nStandings")
//            for (i, team) in standings.enumerated() {
//                description.append("\n\(i+1):\t\(teamDescription(team: team))")
//            }
//            return description
//        }
//    }
//
//    struct Round {
//        
//        let matches: [Match]
//        
//        let standings: [Team]
//    }
//
//    class Match {
//        let homeTeam: Team
//        let awayTeam: Team
//
//        var expectedWinner: Team {
//            if homeTeam.expectedRank < awayTeam.expectedRank {
//                homeTeam
//            } else if homeTeam.expectedRank > awayTeam.expectedRank {
//                awayTeam
//            } else {
//                fatalError()
//            }
//        }
//
//        var expectedLooser: Team {
//            if homeTeam.expectedRank > awayTeam.expectedRank {
//                homeTeam
//            } else if homeTeam.expectedRank < awayTeam.expectedRank {
//                awayTeam
//            } else {
//                fatalError()
//            }
//        }
//
//        init(homeTeam: Team, awayTeam: Team) {
//            self.homeTeam = homeTeam
//            self.awayTeam = awayTeam
//        }
//    }
//
//    enum Team {
//        case ranked(_ rank: Int)
//        case winner(match: Match)
//        case looser(match: Match)
//
//        var expectedRank: Int {
//            switch self {
//            case .ranked(let rank):
//                rank
//            case .winner(let match):
//                match.expectedWinner.expectedRank
//            case .looser(let match):
//                match.expectedLooser.expectedRank
//            }
//        }
//    }
//}


struct TournamentAlgorithms {
  
  static func roundRobinPairs<T>(teams: [T]) -> [(home: T, away: T)] {
    teams.combinations(ofCount: 2).map { ($0[0], $0[1]) }
  }

    static func eliminationModeSchedule(teams: [Team]) -> Schedule {
        let roundsCount = Int(max(0, log2(Double(teams.count)).rounded(.up)))
        let completeTeamsCount = Int(pow(2.0, Double(roundsCount)))

        var rounds: [Round] = []
        for i in 0..<roundsCount {
            let lastRound = rounds.last ?? Round(matches: [], standings: teams)

            let roundSize = completeTeamsCount / Int(pow(2.0, Double(i)))
            let teamsChunks = lastRound.standings.chunks(ofCount: roundSize)
            let partialRound = eliminationModeRound(teams: Array(teamsChunks.first ?? []))
            let round = Round(matches: partialRound.matches, standings: partialRound.standings + Array(teamsChunks.dropFirst().joined()))

            rounds.append(round)
        }

        return Schedule(rounds: rounds)
    }

    static func multilevelModeSchedule(teams: [Team]) -> Schedule {
        let roundsCount = Int(max(0, log2(Double(teams.count)).rounded(.up)))
        let completeTeamsCount = Int(pow(2.0, Double(roundsCount)))

        var rounds: [Round] = []
        for i in 0..<roundsCount {
            let lastRound = rounds.last ?? Round(matches: [], standings: teams)

            let roundSize = completeTeamsCount / Int(pow(2.0, Double(i)))
            let innerRounds = lastRound.standings.chunks(ofCount: roundSize).map { eliminationModeRound(teams: Array($0)) }

            let round = innerRounds.reduce(Round(matches: [], standings: [])) { partialResult, round in
                return Round(matches: partialResult.matches + round.matches, standings: partialResult.standings + round.standings)
            }
            rounds.append(round)
        }

        return Schedule(rounds: rounds)
    }

    // Le squadre vengono accoppiate tipo la prima con l'ultima
    static func eliminationModeRound(teams: [Team]) -> Round {
        guard teams.count > 1 else {
            return Round(matches: [], standings: teams)
        }

        let roundsCount = Int(max(0, log2(Double(teams.count)).rounded(.up)))

        let completeTeamsCount = Int(pow(2.0, Double(roundsCount)))
        // Numero di partite se il numero di squadre fosse la successiva potenza di due.
        let roundSize = completeTeamsCount / 2

        var matches: [Match] = []
        var winnerTeams: [Team] = []
        var looserTeams: [Team] = []

        for i in 0..<roundSize {
            let homeTeamIndex = teams.index(teams.startIndex, offsetBy: i, limitedBy: teams.endIndex-1)
            let awayTeamIndex = teams.index(teams.startIndex, offsetBy: completeTeamsCount-1-i, limitedBy: teams.endIndex-1)

            switch (homeTeamIndex, awayTeamIndex) {
            case (.some(let homeTeamIndex), .some(let awayTeamIndex)):
                let match = Match(homeTeam: teams[homeTeamIndex], awayTeam: teams[awayTeamIndex])
                matches.append(match)
                winnerTeams.append(.winner(match: match))
                looserTeams.insert(.looser(match: match), at: looserTeams.startIndex)
            case (.some(let homeTeamIndex), .none):
                winnerTeams.append(teams[homeTeamIndex])
            default:
                fatalError("This case should not be possible")
            }
        }
        return Round(matches: matches, standings: winnerTeams+looserTeams)
    }

    struct Schedule: CustomStringConvertible {

        let rounds: [Round]

        var standings: [Team] {
            rounds.last?.standings ?? []
        }

        var description: String {
            let matches = rounds.map(\.matches).joined().enumerated()
            func teamDescription(team: Team) -> String {
                switch team {
                case .ranked(let rank):
                    "rank(\(rank))"
                case .winner(let match):
                    "winner(\((matches.first(where: { $0.element === match })?.offset ?? -2) + 1))~\(team.expectedRank)"
                case .looser(let match):
                    "looser(\((matches.first(where: { $0.element === match })?.offset ?? -2) + 1))~\(team.expectedRank)"
                }
            }
            var description = ""
            for (i, round) in rounds.enumerated() {
                description.append("\nRound \(i+1)\n")

                for match in round.matches {
                    let matchID = matches.first(where: { $0.element === match })!.offset
                    description.append("Match \(matchID+1) | \(teamDescription(team: match.homeTeam)) - \(teamDescription(team: match.awayTeam))\n")
                }
            }
            description.append("\nStandings")
            for (i, team) in standings.enumerated() {
                description.append("\n\(i+1):\t\(teamDescription(team: team))")
            }
            return description
        }
    }

    struct Round {

        let matches: [Match]

        let standings: [Team]
    }

    class Match {
        let homeTeam: Team
        let awayTeam: Team

        var expectedWinner: Team {
            if homeTeam.expectedRank < awayTeam.expectedRank {
                homeTeam
            } else if homeTeam.expectedRank > awayTeam.expectedRank {
                awayTeam
            } else {
                fatalError()
            }
        }

        var expectedLooser: Team {
            if homeTeam.expectedRank > awayTeam.expectedRank {
                homeTeam
            } else if homeTeam.expectedRank < awayTeam.expectedRank {
                awayTeam
            } else {
                fatalError()
            }
        }

        init(homeTeam: Team, awayTeam: Team) {
            self.homeTeam = homeTeam
            self.awayTeam = awayTeam
        }
    }

    enum Team {
        case ranked(_ rank: Int)
        case winner(match: Match)
        case looser(match: Match)

        var expectedRank: Int {
            switch self {
            case .ranked(let rank):
                rank
            case .winner(let match):
                match.expectedWinner.expectedRank
            case .looser(let match):
                match.expectedLooser.expectedRank
            }
        }
    }
}
