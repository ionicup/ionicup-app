import Foundation
import SwiftData

@Model
class Rank {
    enum Mode: String, Codable, CaseIterable {
        // A pre-decided team.
        case seeded
        // Another rank.
        case rank
        // The winner of a match.
        case winner
        // The looser of a match.
        case looser
        // The final placement in a tournament, if the tournament  current must be calculated from.
        case placement
    }
    
    var mode: Mode
    
    var tournamentAsInitial: Tournament?
    var tournamentAsInitialSortOrder: Int?
    
    var tournamentAsFinal: Tournament?
    var tournamentAsFinalSortOrder: Int?
    
    var homeMatches: [Match]
    var awayMatches: [Match]
    
    // Seeded
    @Relationship(inverse: \Team.ranks)
    var seededTeam: Team?
    
    // Rank
    @Relationship(inverse: \Rank.children)
    var parent: Rank?
    var children: [Rank]
    
    // Winner / Looser
    var match: Match?
    
    // Placement
    var placement: Int? // Starting from 1
    
    init(
        mode: Mode,
        tournamentAsInitial: Tournament? = nil,
        tournamentAsInitialSortOrder: Int? = nil,
        tournamentAsFinal: Tournament? = nil,
        tournamentAsFinalSortOrder: Int? = nil,
        homeMatches: [Match] = [],
        awayMatches: [Match] = [],
        seededTeam: Team? = nil,
        parent: Rank? = nil,
        children: [Rank] = [],
        match: Match? = nil,
        placement: Int? = nil
    ) {
        self.mode = mode
        self.tournamentAsInitial = tournamentAsInitial
        self.tournamentAsInitialSortOrder = tournamentAsInitialSortOrder
        self.tournamentAsFinal = tournamentAsFinal
        self.tournamentAsFinalSortOrder = tournamentAsFinalSortOrder
        self.homeMatches = homeMatches
        self.awayMatches = awayMatches
        self.seededTeam = seededTeam
        self.parent = parent
        self.children = children
        self.match = match
        self.placement = placement
    }
}

extension Rank {
    
    var selectableTeams: [Team] {
        let tournament = tournamentAsInitial ?? tournamentAsFinal
        return tournament?.selectableTeams ?? []
    }
    
    var selectableRanks: [Rank] {
      if let tournament = tournamentAsInitial {
        tournament.selectableInitialRanks
      } else if let tournament = tournamentAsFinal {
        tournament.selectableFinalRanks
      } else {
        []
      }
    }
    
    var team: Team? {
        switch mode {
        case .seeded:
            seededTeam
        case .rank:
            parent?.team
        case .winner:
            match?.winnerTeam
        case .looser:
            match?.looserTeam
        case .placement:
            fatalError()
        }
    }
}

extension Rank {
    
    var resolvedPlacementRank: Rank? {
        if let tournament = tournamentAsFinal, let placement, tournament.initialRanks.indices.contains(placement) {
            var placements: [Rank: Int] = [:]
            for match in tournament.matches {
                guard let result = match.score?.result, let homeRank = match.homeRank, let awayRank = match.awayRank else {
                    return nil
                }
                
                switch result {
                case .homeWin:
                    placements[homeRank, default: 0] += 3
                    placements[awayRank, default: 0] += 1
                case .awayWin:
                    placements[homeRank, default: 0] += 1
                    placements[awayRank, default: 0] += 3
                case .tie:
                    placements[homeRank, default: 0] += 2
                    placements[awayRank, default: 0] += 2
                }
            }
            let orderedRanks = placements.sorted(using: SortDescriptor(\.value)).map(\.key)
            return placements.sorted(using: SortDescriptor(\.value)).map(\.key)[placement]
        } else {
            return nil
        }
    }
    
    var tournament: Tournament? {
        tournamentAsInitial ?? tournamentAsFinal
    }
    
    var tournamentSortOrder: Int? {
        tournamentAsInitialSortOrder ?? tournamentAsFinalSortOrder
    }
    
    var displayDescription: String {
        guard let tournament, let tournamentSortOrder else {
            assertionFailure("Relationship is broken")
            return "Broken"
        }

      if tournamentAsInitial != nil {
        return "\(tournament.displayName) - Initial - #\(tournamentSortOrder + 1)"
      } else {
        return "\(tournament.displayName) - Final - #\(tournamentSortOrder + 1)"
      }
    }
    
    var displayCompactResolvedName: String {
        switch mode {
        case .seeded:
            team?.compactName ?? "Undefined"
        case .rank:
            parent?.displayCompactResolvedName  ?? "Undefined"
        case .winner:
            match.map { match?.winnerTeam?.compactName ?? "Winner of \($0.displayName)" }  ?? "Undefined"
        case .looser:
            match.map { match?.looserTeam?.compactName ?? "Looser of \($0.displayName)" }  ?? "Undefined"
        case .placement:
            if let tournamentAsFinal, let tournamentAsFinalSortOrder {
                "\(tournamentAsFinalSortOrder) \(tournamentAsFinal)"
            } else {
                "Undefined"
            }
        }
    }
}
