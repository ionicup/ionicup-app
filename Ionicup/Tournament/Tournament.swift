import Foundation
import SwiftData
import Algorithms

@Model
class Tournament {
    
    var displayName: String
    
    enum Mode: Codable, CaseIterable {
        case phases
        case groups
        case multilevel
        // case elimination
        case roundrobin
    }
    
    var mode: Mode
    
    var _season: Season?
    
    var parent: Tournament?
    var parentSortOrder: Int?
    
    @Relationship(deleteRule: .cascade, inverse: \Tournament.parent)
    private var _unsortedChildren: [Tournament]
    var children: [Tournament] {
        get {
            _unsortedChildren.sorted(using: SortDescriptor(\.parentSortOrder))
        } set {
            for (offset, tournament) in newValue.enumerated() {
                tournament.parentSortOrder = offset
            }
            _unsortedChildren = newValue
        }
    }
    
    @Relationship(deleteRule: .cascade, inverse: \Match.tournament)
    private var _unsortedMatches: [Match]
    var matches: [Match] {
        get {
            _unsortedMatches.sorted(using: SortDescriptor(\.tournamentSortOrder))
        } set {
            for (offset, match) in newValue.enumerated() {
                match.tournamentSortOrder = offset
            }
            _unsortedMatches = newValue
        }
    }
    
    @Relationship(deleteRule: .cascade, inverse: \Rank.tournamentAsInitial)
    private var _unsortedInitialRanks: [Rank]
    var initialRanks: [Rank] {
        get {
            _unsortedInitialRanks.sorted(using: SortDescriptor(\.tournamentAsInitialSortOrder))
        } set {
            for (offset, rank) in newValue.enumerated() {
                rank.tournamentAsInitialSortOrder = offset
            }
            _unsortedInitialRanks = newValue
        }
    }
    
    @Relationship(deleteRule: .cascade, inverse: \Rank.tournamentAsFinal)
    private var _unsortedFinalRanks: [Rank]
    var finalRanks: [Rank] {
        get {
            _unsortedFinalRanks.sorted(using: SortDescriptor(\.tournamentAsFinalSortOrder))
        } set {
            for (offset, rank) in newValue.enumerated() {
                rank.tournamentAsFinalSortOrder = offset
            }
            _unsortedFinalRanks = newValue
        }
    }
    
    init(
        displayName: String,
        parent: Tournament? = nil,
        parentSortOrder: Int? = nil,
        children: [Tournament] = [],
        season: Season? = nil,
        mode: Mode = .phases,
        matches: [Match] = []
    ) {
        self.displayName = displayName
        self.parent = parent
        self.parentSortOrder = parentSortOrder
        self._season = season
        self.mode = mode
        self._unsortedMatches = []
        self._unsortedChildren = []
        self._unsortedInitialRanks = []
        self._unsortedFinalRanks = []
        
        self.children = children
        self.matches = matches
    }
}

extension Tournament {
    
    var season: Season? {
        _season ?? parent?.season
    }
    
    var selectableTeams: [Team] {
        season?.teams ?? []
    }
    
    var selectableInitialRanks: [Rank] {
        switch parent?.mode {
        case .phases:
            if let index = siblings.firstIndex(of: self) {
                if index > 0 {
                    return siblings[index-1].finalRanks
                } else {
                    return parent?.initialRanks ?? []
                }
            } else {
                return [] // Fatal Error
            }
        case .groups:
            return parent?.initialRanks ?? []
        case .multilevel, .roundrobin, .none:
            return []
        }
    }

    var selectableFinalRanks: [Rank] {
      initialRanks + children.flatMap(\.finalRanks)
    }

    var siblings: [Tournament] {
        parent?.children ?? []
    }
}

enum TeamSeed {
    case seeded(Team)
    case rank(Rank)
}
